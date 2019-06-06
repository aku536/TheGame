//
//  CardDeckView.swift
//  Set3
//
//  Created by Кирилл Афонин on 19/03/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import UIKit

@IBDesignable
class CardDeckView: UIView {
    
    @IBInspectable
    var isEmpty: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 8.0)
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        roundedRect.fill()
        if isEmpty {
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).setFill()
            roundedRect.fill()
        } else {
            if let cardbackImage = UIImage(named: "cardDeck", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                cardbackImage.draw(in: bounds)
            }
        }
    }
}
