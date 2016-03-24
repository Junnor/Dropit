//
//  BezierPathsView.swift
//  Dropit
//
//  Created by Junor on 16/3/24.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {
    
    private var bezierPath = [String: UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPath[name] = path
        setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPath {
            path.stroke()
        }
    }

}
