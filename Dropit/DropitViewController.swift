//
//  DropitViewController.swift
//  Dropit
//
//  Created by Junor on 16/3/23.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var gameView: BezierPathsView!
    
    lazy var animator: UIDynamicAnimator = {
        let lazillyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazillyCreatedDynamicAnimator.delegate = self
        return lazillyCreatedDynamicAnimator
    }()
    
    private let dropBehavior = DropitBehavior()
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
                gameView.setPath(nil, named: PathNames.Attachment)
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment?.action = { [unowned self] in   // if hasn't the action method, will just excute once
                    if let attachedView = self.attachment?.items.first as? UIView {
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachedView.center)
                        self.gameView.setPath(path, named: PathNames.Attachment)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropBehavior)
    }
    
    struct PathNames {
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let barrierSize = dropSize
        let barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width / 2, y: gameView.bounds.midY - barrierSize.height / 2)
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropBehavior.addBarrier(path, named: PathNames.MiddleBarrier)
        gameView.setPath(path, named: PathNames.MiddleBarrier)
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
    
    
    @IBAction func grapDrop(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        switch sender.state {
        case .Began:
            if let viewToAnchorPoint = lastDroppedView {
                attachment = UIAttachmentBehavior(item: viewToAnchorPoint, attachedToAnchor: gesturePoint)
                lastDroppedView = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            attachment = nil
        default: break
        }
    }
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    var lastDroppedView: UIView?

    private func drop() {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width

        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        lastDroppedView = dropView
        
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

