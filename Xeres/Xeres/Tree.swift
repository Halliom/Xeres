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
            relativeDirection = rand(from: -CGFloat.pi/2, to: CGFloat.pi/2)
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
            
            UIColor.blue.setFill()
            UIRectFill(CGRect(x: pos.x-5, y: pos.y-5, width: 10, height: 10))
            UIColor.black.setFill()
            
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
            if branching {
                sprout()
            }
        }
        
        private func calculateNewBranch() -> CGFloat {
            return 1 - (1 / pow(2, CGFloat(branchPositionAsFraction.count+1)))
        }
    
    }
}

