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

fileprivate func calculateDirection() -> CGPoint {
    
    let direction = randomDirection()
    let x = cos(direction)
    let y = sin(direction)
    
    return CGPoint(x: x, y: y)
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
    
    // Draw the tree, animating it as it goes
    func draw() {
        if let t = trunk {
            t.draw(from: position!)
        } else {
            print("Call grow before draw")
        }
    }
    
    private var position : CGPoint?
    private var trunk : TreeBranch?
    
    // Set len to maximum value so trunk always can grow
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
            direction = calculateDirection()
            
            shape = Stem(dir: direction)
        }
        
        // The TreeBranch grows in length
        private func grow(from position: CGPoint) {
            
            len += 2
            
            shape.draw(position, length: len)
        }
        
        // A new TreeBranch sprouts from this one
        private func sprout() {
            
        }
        
        func draw(from position: CGPoint) {
            
            let growing = root.length/self.length * decision() > 0.9
            
            if growing {
                grow(from: position)
            }
            
            for i in 0...branch.count {
                let pos = shape.getPointOnStem(fraction: branchPositionAsFraction[i])
                branch[i].draw(from: pos)
            }
            
            let branching = length > 10 && decision() > 0.9
            
            if branching {
                let branchPosition = calculateNewBranch()
                
                branchPositionAsFraction.append(branchPosition)
                let pos = shape.getPointOnStem(fraction: branchPosition)
                
                let newBranch = TreeBranch(from: pos, withRoot: self)
                branch.append(newBranch)
                newBranch.draw(from: pos)
                
            }
            
            
            
        }
        
        private func calculateNewBranch() -> CGFloat {
            return 1 - (1 / pow(2, CGFloat(branchPositionAsFraction.count)))
        }
    
        
        private let root : Branchable
        private var branch : [TreeBranch] = []
        private var branchPositionAsFraction : [CGFloat] = []
        
        private var position : CGPoint
        private let direction : CGPoint
        
        private var len : CGFloat = 0
        var length : CGFloat {
            get {
                return len
            }
        }
        
        private var shape : Stem!
        
        
        
    }
}

