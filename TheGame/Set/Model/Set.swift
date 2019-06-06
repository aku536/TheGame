//
//  Set.swift
//  Set
//
//  Created by Кирилл Афонин on 22/01/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import Foundation

struct Set {
    
    private(set) var allCards = [PlayingCard]()
    
    private(set) var selectedCards = [PlayingCard]()
    
    // contains matched cards
    // when matching replaces matched cards with new ones or
    // removes them from the deck
    private(set) var matchedCards = [PlayingCard]()
    
    // cards on the deck
    private(set) var dealtCards = [PlayingCard]()
    
    private(set) var score = 0
    
    // creates a deck and adds 12 cards to the dealtCards[]
    init() {
        for symbol in PlayingCard.Symbol.all {
            for quantity in PlayingCard.Quantity.all {
                for color in PlayingCard.Color.all {
                    for stroke in PlayingCard.Stroke.all {
                        allCards.append(PlayingCard(symbols: symbol, quantity: quantity, colors: color, strokes: stroke))
                    }
                }
            }
        }
        for _ in 0...11 {
            if let card = takeCard() {
                dealtCards.append(card)
            }
        }
    }
    
    // takes card from deck or returns nil
    private mutating func takeCard() -> PlayingCard? {
        if !allCards.isEmpty {
            return allCards.remove(at: Int.random(in: 0..<allCards.count))
        } else {
            return nil
        }
    }
    
    // adds/removes card to/from the selectedCards[]
    mutating func selectCard(at index: Int) {
        if selectedCards.count > 2 {
            replaceOrRemoveCard()
            selectedCards.removeAll()
        } else {
            let card = dealtCards[index]
            if selectedCards.contains(card) {
                selectedCards.remove(card)
                score -= 1
            } else {
                selectedCards.append(card)
                if selectedCards.count > 2 {
                    if isMatching(cards: selectedCards){
                        matchedCards += selectedCards
                        score += 5
                    } else {
                        score -= 3
                    }
                }
            }
        }

    }
    
    // checks matching according to the Set rules
    private func isMatching (cards: [PlayingCard]) -> Bool {
        let sum = [
            cards.reduce(0, {$0 + $1.symbols.rawValue}),
            cards.reduce(0, {$0 + $1.quantity.rawValue}),
            cards.reduce(0, {$0 + $1.colors.rawValue}),
            cards.reduce(0, {$0 + $1.strokes.rawValue})
        ]
        return sum.reduce(true, {$0 && ($1 % 3 == 0)})
        //return true //for debugging
    }
    
    // adds 3 new cards to the dealtCards[]
    mutating func deal3Cards() {
        for _ in 0...2 {
            if let card = takeCard() {
                if selectedCards.count == 3 && isMatching(cards: selectedCards) {
                    replaceOrRemoveCard()
                } else {
                    dealtCards.append(card)
                    score -= 2
                }
            }
        }
        selectedCards.removeAll()
    }
    
    mutating func replaceOrRemoveCard() {
        for matchedCard in matchedCards {
            for cardToCheck in dealtCards {
                if cardToCheck == matchedCard {
                    let cardIndex = dealtCards.index(of: cardToCheck)
                    if let newCard = takeCard() {
                        if dealtCards.count <= 12 {
                            dealtCards[cardIndex!] = newCard
                        } else {
                            dealtCards.remove(at: cardIndex!)
                        }
                    } else {
                        dealtCards.remove(at: cardIndex!)
                    }
                }
            }
        }
    }
    
    // shuffles cards on the deck
    mutating func shuffle() {
        dealtCards.shuffle()
    }
}

// removes element from array. Necessary to check if the array contains the element before
extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        _ = index(of: element).flatMap { self.remove(at: $0) }
    }
}
