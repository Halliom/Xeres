//
//  Tree.swift
//  Xeres
//
//  Created by Johan Moritz on 2017-05-02.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit

fileprivate func myRand(from: CGFloat, to: CGFloat) -> CGFloat {
    return ((to - from) * CGFloat(arc4random()) / CGFloat(UINT32_MAX)) + from
}

fileprivate func randomDirection() -> CGFloat {
    
    return myRand(from: 0, to: 2*CGFloat.pi)
}

fileprivate func decision() -> CGFloat {
    
    return myRand(from: 0, to: 1)
}


protocol Branchable {
    var length : CGFloat {
        get
    }
}



class Tree : Branchable {
    
    static let sharedInstance = Tree()
    
    init() { }
    
    // Start growing the tree
    func grow(from pos: CGPoint) {
        if position == nil {
            position = pos
            trunk = TreeBranch(from: pos, withRoot: self)
        }
    }
    
    func draw() {
        if let t = trunk {
            t.draw()
        } else {
            print("Call grow before draw")
        }
    }
    
    private var position : CGPoint?
    private var trunk : TreeBranch?
    
    private var len : CGFloat = CGFloat.greatestFiniteMagnitude
    var length : CGFloat {
        get {
            return len
        }
    }

    
    
    class TreeBranch : Branchable {
        
        init(from pos: CGPoint, withRoot root: Branchable) {
            self.root = root
            position  = pos
            direction = randomDirection()
            shape.move(to: position)
        }
        
        // The TreeBranch grows in length
        private func grow() {
            let X  : CGFloat = cos(direction)
            let Y  : CGFloat = sin(direction)
            
            position = CGPoint(x: position.x + X, y: position.y + Y)
            
            shape.addLine(to: position)
        }
        
        // A new TreeBranch sprouts from this one
        private func sprout() {
            
        }
        
        func draw() {
            let growing = root.length/self.length * decision() > 0.4
            print("grow: " + String(growing))
            if growing {
                grow()
            }
            
            shape.stroke()
        }
    
        
        private let root : Branchable
        private var branches : [TreeBranch] = []
        private var position : CGPoint
        private let direction : CGFloat
        
        private var len : CGFloat = 0
        var length : CGFloat {
            get {
                return len
            }
        }
        
        private var shape = UIBezierPath()
        
        
        
    }
}

