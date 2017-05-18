//
//  PlantScene.swift
//  Xeres
//
//  Copyright © 2017 wiemor. All rights reserved.

import Foundation
import CoreMotion
import SpriteKit

class PlantScene: SKScene {
    
    var tree: Tree?
    
    var sun: Sun!
    
    var motionManager = CMMotionManager()
    var accumulatedRotation = 0.0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor.white
    }
    
    override func didMove(to view: SKView) {
        
        self.sun = Sun(position: CGPoint(x: 0, y: 0),
                       topOfScreen: self.frame.maxY - 175,
                       minWidth: -self.frame.maxX,
                       maxWidth: self.frame.maxX)
        addChild(sun)
        
        motionManager.startAccelerometerUpdates()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        
        let touchLocation = touch.location(in: self)
        
        if tree == nil {
            // Begin growing the tree
            self.tree = Tree()
            self.addChild(tree!)
            self.tree!.grow(from: CGPoint(x: 0, y: -self.frame.maxY + 175))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        tree?.update()
        
        if let data = motionManager.accelerometerData {
            accumulatedRotation = data.acceleration.x
        }
        sun.move(amount: CGFloat(accumulatedRotation) * 0.01)
        accumulatedRotation = 0
    }
}
