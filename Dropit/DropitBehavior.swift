//
//  DropitBehavior.swift
//  Dropit
//
//  Created by Junor on 16/3/23.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior {

    private let gravity = UIGravityBehavior()
    
    private lazy var collider: UICollisionBehavior = {
        let lazillyCreatedCollider = UICollisionBehavior()
        lazillyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazillyCreatedCollider
    }()
    
    private lazy var dropBehavior: UIDynamicItemBehavior = {
        let lazillyDropBehavior = UIDynamicItemBehavior()
        lazillyDropBehavior.allowsRotation = false
        lazillyDropBehavior.elasticity = 0.75
        return lazillyDropBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addDrop(drop: UIView) {
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop: UIView) {
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
    
}
