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
    var length: CGFloat {
        get
    }
  
    var direction: CGFloat {
        get
    }
    
    var depth: Int {
        get
    }
}


// Constants describing the look of the tree

fileprivate let MAX_LENGTH: CGFloat         = 200
fileprivate let MAX_BRANCHES                = 100
fileprivate let BASE_GROWTH_SPEED: CGFloat  = 1.01
fileprivate let MAX_CHILD_BRANCHES          = 5
fileprivate let BRANCH_SPREAD: CGFloat      = CGFloat.pi // A disc slice of this angle


fileprivate var NUMBER_OF_BRANCHES  = 0      // An ugly global, please don't create multiple instances of Tree




class Tree : SKNode, Branchable {

    private var trunk : TreeBranch?
    var direction = CGFloat.pi/2

    
    private var len: CGFloat
    
    var length: CGFloat {
        get {
            return len
        }
    }
    
    var depth: Int {
        get {
            return 0
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
        
        var direction : CGFloat
        private var relativeDirection : CGFloat
        
        private var len : CGFloat
        var length : CGFloat {
            get {
                return len
            }
        }
        
        private var growthSpeed: CGFloat
        
        var depth: Int {
            get {
                return depthCalculation()
            }
        }
        
        private func depthCalculation() -> Int {
            return 1 + root.depth
        }
        
        private let branchNo : Int
        
        private var shape : Stem!
        private var leaf : Leaf?
        
        init(from pos: CGPoint, withRoot root: Branchable) {
            self.root = root
            
            branch = []
            branchPositionAsFraction = []
            numSubBranches = 0
            
            if root.depth == 0 {
                relativeDirection = 0
            } else {
                relativeDirection = rand(from: -BRANCH_SPREAD/2, to: BRANCH_SPREAD/2)
            }
            
            direction = root.direction + relativeDirection
            len = 1
            growthSpeed = BASE_GROWTH_SPEED
            
            branchNo = NUMBER_OF_BRANCHES
            
            super.init()
            shape = Stem(dir: polarToCartesian(direction: direction))
            self.addChild(shape)
            self.position  = pos
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")

        }
        
        // The TreeBranch grows in length
        private func grow() {
            if len > 2/3 * MAX_LENGTH && growthSpeed > 1 {
                growthSpeed *= 0.999                            // what is good number for this??? -= 0.00001 ???
            }
            len *= growthSpeed
        }
        
        // A new TreeBranch sprouts from this one
        private func sprout() {
            let branchPosition = calculateNewBranch()
            
            branchPositionAsFraction.append(branchPosition)
            let pos = shape.getPointOnStem(fraction: branchPosition)
            
            let newBranch = TreeBranch(from: pos, withRoot: self)
            self.addChild(newBranch)

            branch.append(newBranch)
        }
        
        func update(from position: CGPoint) {
            
            self.position = position
            
            let growing = length < MAX_LENGTH && root.length/self.length > 1.5 && decision() > 0.15
            if growing {
                grow()
            } else {
                if leaf == nil {
                    leaf = Leaf(offset: shape.getTopPoint(), direction: polarToCartesian(direction: direction))
                    self.addChild(leaf!)
                }
            }
            
            direction = root.direction + relativeDirection
            shape.update(length: len, dir: polarToCartesian(direction: direction))

            
            for i in 0..<branch.count {
                let pos = shape.getPointOnStem(fraction: branchPositionAsFraction[i])
                branch[i].update(from: pos)
            }
            
            let branching = length > 10 && decision() < 2*length/MAX_LENGTH && branch.count < MAX_CHILD_BRANCHES
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
