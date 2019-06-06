//
//  CardBehavior.swift
//  Set3
//
//  Created by Кирилл Афонин on 26/03/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior, UIDynamicAnimatorDelegate {
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 0.9
        behavior.resistance = 0
        return behavior
    }()
    
    var snapPoint = CGPoint()
    
    private func snap(_ item: UIDynamicItem) {
        let snap = UISnapBehavior(item: item, snapTo: snapPoint)
        snap.damping = 0.2
        addChildBehavior(snap)
    }
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.pi.random
        push.magnitude = CGFloat(3).random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.collisionBehavior.removeItem(item)
            self.snap(item)
        }
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

extension CGFloat {
    var random: CGFloat {
        return self - CGFloat(Int.random(in: 0..<(Int(self))))
    }
}
