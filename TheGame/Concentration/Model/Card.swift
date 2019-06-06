//
//  Card.swift
//  Concentration
//
//  Created by Кирилл Афонин on 10/01/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import Foundation

struct Card: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched =  false
    private var identifier: Int
    var wasFacedUp = false
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
