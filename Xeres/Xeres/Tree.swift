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
    
    // Set len to maximum value so trunk always can grow
    private var len : CGFloat
    var length : CGFloat {
        get {
            return len
        }
    }

    private let scene: SKScene
    
    
    init(scene: SKScene) {
        self.scene = scene
        len = CGFloat.greatestFiniteMagnitude
    }
    
    // Start growing the tree
    func grow(from pos: CGPoint) {
        if position == nil {
            position = pos
            trunk = TreeBranch(scene: scene, from: pos, withRoot: self)
        }
    }
    
    // Update the structure of the tree
    func update() {
        if let t = trunk {
            t.update(from: position!)
            //t.forceOnRoot()
        } else {
            print("Call grow before draw")
        }
    }
    
    class TreeBranch : Branchable {
        
        private let root : Branchable
        private var branch : [TreeBranch]
        private var branchPositionAsFraction : [CGFloat]
        
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
        private let scene: SKScene
        
        init(scene: SKScene, from pos: CGPoint, withRoot root: Branchable) {
            self.root = root
            
            branch = []
            branchPositionAsFraction = []
            
            position  = pos
            relativeDirection = rand(from: -CGFloat.pi/4, to: CGFloat.pi/4)
            direction = root.direction + relativeDirection
            len = 0
            
            self.scene = scene
            shape = Stem(dir: polarToCartesian(direction: direction))
            scene.addChild(shape)
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
            branch.append(newBranch)
            newBranch.update(from: pos)
        }
        
        func update(from position: CGPoint) {
            
            self.position = position
            
            let growing = length < MAX_LENGTH && root.length/self.length > 1.5 && decision() > 0.15
            if growing {
                grow()
            }
            
            direction = root.direction + relativeDirection
            
            shape.update(position, length: len, dir: polarToCartesian(direction: direction))
            
            for i in 0..<branch.count {
                let pos = shape.getPointOnStem(fraction: branchPositionAsFraction[i])
                branch[i].update(from: pos)
                
            }
            
            let branching = length > 10 && decision() < 2*length/MAX_LENGTH && branch.count < 5
            if branching && NUMBER_OF_BRANCHES < MAX_BRANCHES {
                
                // Bend branches based on number of child branches
                if direction > CGFloat.pi/2 && direction < 3*CGFloat.pi/2 {
                    relativeDirection += CGFloat.pi/(30*CGFloat(branch.count+1))
                } else {
                    relativeDirection -= CGFloat.pi/(30*CGFloat(branch.count+1))
                }
                

                
                sprout()
                NUMBER_OF_BRANCHES += 1
            }
        }
        
        private func calculateNewBranch() -> CGFloat {
            return 1 - (1 / pow(2, CGFloat(branchPositionAsFraction.count+1)))
        }
  
        
        func updatePhysics() {
            // Update the direction of the branch based on the forces on in
            // Forces: 
            //      Down:  mass from child branches
            //      Up:    strength in the branch
        }
        
        func forceOnRoot() -> CGFloat {
            // Sum up the force of the leaf TreeBranches
            var forceFromChildren : CGFloat = 0
            for childBranch in branch {
                forceFromChildren += childBranch.forceOnRoot()
            }
            
            let endpoint = shape.getTopPoint()
            let distance = abs(position.x - endpoint.x)/20
            
            // Calculate the resistance/strength in the branch
            let weight      = length
            let strength    = 100/(pow(distance, 0.4)/length) //+ weight
            
            // Update the bend on the branch to strengthen it
            if strength < forceFromChildren {
                if direction > CGFloat.pi/2 && direction < 3*CGFloat.pi/4 {
                    // Leaning to the left
                    relativeDirection += CGFloat.pi/200
                } else if direction > CGFloat.pi/4 && direction < CGFloat.pi/2 {
                    // to the right
                    relativeDirection -= CGFloat.pi/200
                }
            }
            
            // Calculate the force on the root branch
            let forceOnRoot = weight + forceFromChildren*distance
            
            if root.length > 1000 {
                print("strength " + String(describing: strength))
                print("weight " + String(describing: weight))
                print("forceFromChildren " + String(describing: forceFromChildren))
                print("forceOnRoot " + String(describing: forceOnRoot))
                print()
                
            }
            
            return forceOnRoot
        }
    
    }
}

