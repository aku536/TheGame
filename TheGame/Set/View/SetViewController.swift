//
//  ViewController.swift
//  Set
//
//  Created by Кирилл Афонин on 22/01/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

// TODO: 1). add deleting cards animation
//       2). fix autodealing
//       3). fix flyaway animation
//       4). add deck counting label (string to deckView)

import UIKit

class SetViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    // MARK: Outlets
    
    // changes the number of points
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = "Score: \(game.score)"
        }
    }
    
    // deals 3 more cards
    @IBOutlet weak var dealButton: UIButton!
    
    // a view with all cards in game
    @IBOutlet weak var deckView: DeckView!
   
    // a view of deck
    @IBOutlet weak var startDeck: CardDeckView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            startDeck.addGestureRecognizer(tap)
        }
    }
    
    // stack view with buttons and labels
    @IBOutlet weak var infoStack: UIStackView!
    
    private var game = Set()
    
    // cards that matches and should be removed
    private var droppingCards: [SetCardView] = []
    
    private lazy var animator : UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.deckView)
        animator.delegate = self
        return animator
    }()
    lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // start game immediatly when load
        updateViewFromModel()
    }
    
    // adds 3 more cards on the deck and updates their views
    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Set()
        deckView.cardViews.removeAll()
        updateViewFromModel()
    }
    
    // MARK: Updating views
    
    // main function that connects view and model
    private func updateViewFromModel() {
        // deletes matchedCards (if number of cards in model less then number of cards on the deck)
        if deckView.cardViews.count - game.dealtCards.count > 0 {
            let cardsInGame = deckView.cardViews[..<game.dealtCards.count]
            deckView.cardViews = Array(cardsInGame)
        }
        
        // creates or updates a card view
        for index in game.dealtCards.indices {
            let card = game.dealtCards[index]
            if index > (deckView.cardViews.count - 1) {
                let cardView = SetCardView()
                cardView.alpha = 0
                updateCardView(cardView, for: card)
                addTapGestureRecognizer(for: cardView)
                deckView.cardViews.append(cardView)
            } else {
                let cardView = deckView.cardViews[index]
                updateCardView(cardView, for: card)
            }
        }
        // updates outlets' views
        scoreLabel.text = "Score: \(game.score)"
        if game.allCards.count == 0 {
            dealButton.isEnabled = false
            dealButton.alpha = 0.5
        } else {
            dealButton.isEnabled = true
            dealButton.alpha = 1
        }
        
    }
    
    // displays card view or highlights it and animates them
    private func updateCardView(_ cardView: SetCardView, for card: PlayingCard) {
        // settings the view of a card
        cardView.symbolInt = card.symbols.rawValue
        cardView.colorInt = card.colors.rawValue
        cardView.fillInt = card.strokes.rawValue
        cardView.count = card.quantity.rawValue
        cardView.isSelected = game.selectedCards.contains(card)
        
        dealAnimation(card: cardView)

        // highlights card view depending on is it selected, matched or mismatched
        // and starts the flyaway animation if it is a set
        if game.selectedCards.count > 2 {
            if game.matchedCards.contains(card) {
                cardView.isMatched = true
                cardView.alpha = 0
                dropAnimation(card: cardView)
            } else if game.selectedCards.contains(card) {
                cardView.isMatched = false
            }
        } else {
            cardView.isMatched = nil
        }
    }
    
    // animation of adding new cards to the game
    private func dealAnimation(card: SetCardView) {
        if card.alpha == 0 {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                let cardViewCenter = card.center
                card.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi/2)
                card.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                card.center = self.view.convert(self.infoStack.center, to: self.deckView)
                card.isFaceUp = false
                card.alpha = 1
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0,
                                                               animations: {
                                                                card.center = cardViewCenter
                                                                card.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
                }, completion: { finished in
                    if card.isFaceUp == false {
                        UIView.transition(with: card, duration: 0.5, options: [.transitionFlipFromLeft],
                                          animations: { card.isFaceUp = true })
                    }

                })
            }
        }
    }

    // adds a new view and pushes it instead of matched card
    private func dropAnimation(card: SetCardView) {
        let droppingCard: SetCardView = card.copy()
        droppingCards += [droppingCard]
        deckView.addSubview(droppingCard)
        cardBehavior.snapPoint = view.convert(self.infoStack.center, to: self.deckView)
        cardBehavior.addItem(droppingCard)
        
    }
    
    // when push animation is end, animate putting cards in the deck
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        droppingCards.forEach { (card) in
            UIView.transition(with: card, duration: 0.5,
                              options: [.transitionFlipFromLeft],
                              animations: {
                                card.isFaceUp = false
                                card.transform = CGAffineTransform.identity
                                    .rotated(by: CGFloat.pi / 2.0)
                                card.bounds = CGRect(x: 0.0, y: 0.0,
                                                        width: 0.8*card.bounds.width,
                                                        height: 0.8*card.bounds.height)
                                 },
                              completion: { finished in
                                self.cardBehavior.removeItem(card)
                                card.removeFromSuperview()
                                self.droppingCards.remove(card)
                                if self.game.dealtCards.count > 0 { self.game.selectCard(at: 0) }
                                self.updateViewFromModel()
                                
            })
        }
    }
    
    // adds tapGesture to a card's view
    private func addTapGestureRecognizer(for cardView: SetCardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizedBy:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }
    
    // add/remove a card to/from the selectedCards[]
    @objc private func tapCard(recognizedBy recognizer:UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view! as? SetCardView {
                game.selectCard(at: deckView.cardViews.index(of: cardView)!)
            }
        default: break
        }
        updateViewFromModel()
    }
}
