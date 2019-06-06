//
//  DeckView.swift
//  Set
//
//  Created by Кирилл Афонин on 04/03/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import UIKit

class DeckView: UIView {

    var cardViews = [SetCardView]() {
        willSet { removeSubviews(); layoutIfNeeded() }
        didSet { addSubviews(); setNeedsLayout() }
    }
    
    private func removeSubviews() {
        for card in cardViews {
            card.removeFromSuperview()
        }
        layoutIfNeeded()
    }
    
    private func addSubviews() {
        for card in cardViews {
            addSubview(card)
        }
        layoutIfNeeded()
    }
    
    // creates a card view and places it in a proper way
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cellAspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                if cardViews.count > (row * grid.dimensions.columnCount + column) {
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.5, delay: 0,
                        animations: { self.cardViews[row * grid.dimensions.columnCount + column].frame = grid[row, column]!.insetBy(dx: Constants.spacingX, dy: Constants.spacingY) })
                }
            }
        }
    }

    struct Constants {
        static let cellAspectRatio: CGFloat = 0.7
        static let spacingX: CGFloat = 2.0
        static let spacingY: CGFloat = 2.0
    }
}
