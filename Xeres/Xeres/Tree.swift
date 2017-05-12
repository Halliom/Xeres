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

fileprivate func polarToCartesian(direction: CGFloat) -> CGPoint {
    let x = cos(direction)
    let y = sin(direction)
    
    return CGPoint(x: x, y: y)
}

protocol Branchable {
    var length : CGFloat {
        get
    }
  
    var direction: CGFloat {
        get
    }
}

fileprivate let MAX_LENGTH : CGFloat = 200

fileprivate let MAX_BRANCHES = 100
fileprivate var NUMBER_OF_BRANCHES = 0

class Tree : Branchable {

    
    private var position : CGPoint?
    private var trunk : TreeBranch?
    var direction = CGFloat.pi/2

    
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
            t.update(from: position!)
            t.updatePhysics()
          
        } else {
            print("Call grow before draw")
        }
    }
    
    class TreeBranch: SKNode, Branchable {
        
        private let root : Branchable
        private var branch : [TreeBranch]
        private var branchPositionAsFraction : [CGFloat]
        private var numSubBranches : Int
        
        private var position : CGPoint
        var direction : CGFloat
        private var relativeDirection : CGFloat
        
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
            numSubBranches = 0
            
            position  = pos
            relativeDirection = rand(from: -CGFloat.pi/4, to: CGFloat.pi/4)
            direction = root.direction + relativeDirection
            len = 0
            
            super.init()
            shape = Stem(dir: polarToCartesian(direction: direction))
            self.addChild(shape)
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
            
            let newBranch = TreeBranch(scene: scene, from: pos, withRoot: self)
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
                    leaf = Leaf(offset: shape.getTopPoint(), direction: direction)
                    self.addChild(leaf!)
                }
            }
            
            direction = root.direction + relativeDirection
            shape.update(position, length: len, dir: polarToCartesian(direction: direction))

            
            for i in 0..<branch.count {
                let pos = shape.getPointOnStem(fraction: branchPositionAsFraction[i])
                branch[i].update(from: pos)
            }
            
            let branching = length > 10 && decision() < 2*length/MAX_LENGTH && branch.count < 5
            if branching && NUMBER_OF_BRANCHES < MAX_BRANCHES {
                
                sprout()
                NUMBER_OF_BRANCHES += 1
            }
        }
        
        private func calculateNewBranch() -> CGFloat {
            return 1 - (1 / pow(2, CGFloat(branchPositionAsFraction.count+1)))
        }
        
        private func numberOfSubBranches() -> Int {
            var sum = branch.count
            for b in branch {
                sum += b.numberOfSubBranches()
            }
            return sum
        }
  
        
        func updatePhysics() {
            
            let currentNumSubBranches = numberOfSubBranches()
            let addedWeight = currentNumSubBranches - numSubBranches
            
            if addedWeight > 0 {
                
                // Bend branches based on number of child branches
                if direction > CGFloat.pi/2 && direction < 3*CGFloat.pi/2 {
                    relativeDirection += CGFloat.pi/(1000*CGFloat(addedWeight))
                } else {
                    relativeDirection -= CGFloat.pi/(1000*CGFloat(addedWeight))
                }
                
                numSubBranches = currentNumSubBranches
                
                for b in branch {
                    b.updatePhysics()
                }
            }
        }
    }
}
