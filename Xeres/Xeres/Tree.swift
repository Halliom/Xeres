//
//  Tree.swift
//  Xeres
//
//  Created by Johan Moritz on 2017-05-02.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

fileprivate func randomDirection() -> CGFloat {
    
    return rand(from: 0*CGFloat.pi, to: CGFloat.pi)
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

fileprivate let MAX_LENGTH : CGFloat = 200

class Tree: SKNode, Branchable {
    
    private var trunk: TreeBranch?
    
    private var len : CGFloat
    
    var length : CGFloat {
        get {
            return len
        }
    }
    
    override init() {
        // Set len to maximum value so trunk always can grow
        len = CGFloat.greatestFiniteMagnitude

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Start growing the tree
    func grow(from pos: CGPoint) {
        trunk = TreeBranch(from: CGPoint(), withRoot: self)
        self.addChild(trunk!)
    }
    
    // Update the structure of the tree
    func update() {
        if let t = trunk {
            t.update(from: position)
        } else {
            print("Call grow before draw")
        }
    }
    
    class TreeBranch: SKNode, Branchable {
        
        private let root: Branchable
        private var branch: [TreeBranch]
        private var branchPositionAsFraction: [CGFloat]
        
        private let direction: CGPoint
        private var leaf: Leaf?
        
        private var len : CGFloat
        var length : CGFloat {
            get {
                return len
            }
        }
        
        private var shape : Stem!
        
        init(from pos: CGPoint, withRoot root: Branchable) {
            self.root = root
            
            branch = []
            branchPositionAsFraction = []
            
            direction = calculateDirection()
            len = 0
            
            super.init()
            shape = Stem(dir: direction)
            self.addChild(shape)
            
            self.position = pos
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // The TreeBranch grows in length
        private func grow() {
            if len == 0 {
                len = 1
            } else {
                len *= 1.01
            }
        }
        
        // A new TreeBranch sprouts from this one
        private func sprout() {
            let branchPosition = calculateNewBranch()
            
            branchPositionAsFraction.append(branchPosition)
            let pos = shape.getPointOnStem(fraction: branchPosition)
            
            let newBranch = TreeBranch(from: pos, withRoot: self)
            self.addChild(newBranch)
            branch.append(newBranch)
            newBranch.update(from: pos)
        }
        
        func update(from position: CGPoint) {
            self.position = position
            
            let growing = length < MAX_LENGTH && root.length/self.length > 1.5 && decision() > 0.15
            
            if growing {
                grow()
            } else {
                if leaf == nil {
                    leaf = Leaf(offset: shape.getPointOnStem(fraction: 1.0), direction: direction)
                }
            }
            
            shape.update(length: len)
            
            for i in 0..<branch.count {
                let pos = shape.getPointOnStem(fraction: branchPositionAsFraction[i])
                branch[i].update(from: pos)
            }
            
            let branching = length > 10 && decision() < 2*length/MAX_LENGTH && branch.count < 5
            
            if branching {
                sprout()
            }
        }
        
        private func calculateNewBranch() -> CGFloat {
            return 1 - (1 / pow(2, CGFloat(branchPositionAsFraction.count+1)))
        }
    }
}
