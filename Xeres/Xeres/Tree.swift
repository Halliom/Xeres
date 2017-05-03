//
//  Tree.swift
//  Xeres
//
//  Created by Johan Moritz on 2017-05-02.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit



fileprivate func randomDirection() -> CGFloat {
    
    return rand(from: 5/4*CGFloat.pi, to: 7/4*CGFloat.pi)
}

fileprivate func decision() -> CGFloat {
    
    return rand(from: 0, to: 1)
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
        private func grow() {
            
            len += 30
        }
        
        // A new TreeBranch sprouts from this one
        private func sprout() {
            
        }
        
        func draw(from position: CGPoint) {
            
            self.position = position
            
            let growing = root.length/self.length > 1.1 //&& decision() > 0.15
            
            if growing {
                grow()
            }
            
            
            shape.draw(position, length: len)
            
            for i in 0..<branch.count {
                let pos = shape.getPointOnStem(fraction: branchPositionAsFraction[i])
                branch[i].draw(from: pos)
                
                UIColor.blue.setFill()
                UIRectFill(CGRect(x: pos.x-5, y: pos.y-5, width: 10, height: 10))
                UIColor.black.setFill()
            }
            
            let branching = length > 10 && decision() > 0.6
            
            if branching {
                let branchPosition = calculateNewBranch()
                
                branchPositionAsFraction.append(branchPosition)
                let pos = shape.getPointOnStem(fraction: branchPosition)
                
                UIColor.blue.setFill()
                UIRectFill(CGRect(x: pos.x-5, y: pos.y-5, width: 10, height: 10))
                UIColor.black.setFill()
                
                let newBranch = TreeBranch(from: pos, withRoot: self)
                branch.append(newBranch)
                newBranch.draw(from: pos)
                
            }
            
            
            
        }
        
        private func calculateNewBranch() -> CGFloat {
            return 1 - (1 / pow(2, CGFloat(branchPositionAsFraction.count+1)))
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

