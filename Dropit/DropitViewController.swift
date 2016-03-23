//
//  DropitViewController.swift
//  Dropit
//
//  Created by Junor on 16/3/23.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var gameView: UIView!
    
    lazy var animator: UIDynamicAnimator = {
        let lazillyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazillyCreatedDynamicAnimator.delegate = self
        return lazillyCreatedDynamicAnimator
    }()
    
    private let dropBehavior = DropitBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropBehavior)
    }
    
    private var dropsPerRow = 10
    
    private var dropSize: CGSize {   // computed property
        let size = self.view.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    // MARK: - DynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    // MARK: - Drop & Remove
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }

    private func drop() {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width

        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        dropBehavior.addDrop(dropView)
    }
    
    func removeCompletedRow() {
        var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.width)
        
        repeat {
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropFound = [UIView]()
            var rowIsComplete = true
            
            for _ in 0..<dropsPerRow {
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil) {
                    if hitView.superview == gameView {
                        dropFound.append(hitView)
                    } else {
                        rowIsComplete = false
                    }
                }
                dropFrame.origin.x += dropSize.width
        
            }
            
            if rowIsComplete {
                dropsToRemove += dropFound
            }
        
        } while dropsToRemove.count == 0 && dropFrame.origin.y > 0.0
        
        for drop in dropsToRemove {
            dropBehavior.removeDrop(drop)
        }
    }
}


// MARK: - Extension

// With private, just this file can use it
private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 5 {
        case 0: return greenColor()
        case 1: return blueColor()
        case 2: return orangeColor()
        case 3: return purpleColor()
        case 4: return redColor()
        default: return blackColor()
        }
    }
}

