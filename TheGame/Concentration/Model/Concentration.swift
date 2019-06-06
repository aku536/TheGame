//
//  Concentration.swift
//  Concentration
//
//  Created by Кирилл Афонин on 10/01/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    private(set) var points = 0
    private(set) var flipCount = 0
    private(set) var theEnd = false
    
    init(numberOfPairsOfCards: Int) {
        //assert(numberOfPairsOfCards < 0, "Concentration.init(\(numberOfPairsOfCards)): there is no pairs")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }

    private var indexOfOneAndOnlyFaceUpCards: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCards(ar \(index): there is no such index")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCards, matchIndex != index {
                // check is card match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    points += 2
                    cards[matchIndex].wasFacedUp = false
                    cards[index].wasFacedUp = false
                    if cards.indices.filter({ cards[$0].isMatched }).count == cards.indices.count {
                        theEnd = true
                        cards[matchIndex].isFaceUp = false
                        cards[index].isFaceUp = false
                        return
                    }
                }
                cards[index].isFaceUp = true
                if cards[index].wasFacedUp {
                    points -= 1
                } else {
                    cards[index].wasFacedUp = true
                }
                if cards[matchIndex].wasFacedUp {
                    points -= 1
                } else {
                    cards[matchIndex].wasFacedUp = true
                }
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCards = index
            }
        }
    }
    
    mutating func resetGame() {
        points = 0
        flipCount = 0
        theEnd = false
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].wasFacedUp = false
        }
    }
}

extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
