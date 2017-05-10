//
//  PlantScene.swift
//  Xeres
//
//  Copyright © 2017 wiemor. All rights reserved.

import Foundation
import CoreMotion
import SpriteKit

class PlantScene: SKScene {
    
    static var scene: PlantScene!
    
    var tree: Tree!
    
    var sun: Sun!
    
    var motionManager = CMMotionManager()
    var accumulatedRotation = 0.0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        PlantScene.scene = self
        self.tree = Tree(scene: self)
    }
    
    override func didMove(to view: SKView) {
        self.sun = Sun(position: CGPoint(x: 0, y: 0),
                       topOfScreen: self.frame.maxY - 175,
                       minWidth: -self.frame.maxX,
                       maxWidth: self.frame.maxX)
        addChild(sun)
        
        // Start receiving gyro updates
        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: motionUpdate)
    }
    
    func motionUpdate(gyroData: CMGyroData?, error: Error?) {
        if let rotationRate = gyroData?.rotationRate {
            accumulatedRotation += rotationRate.x
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.removeAllChildren()
        
        tree.grow(from: CGPoint(x: 0, y: -frame.maxY / 2))
        
        tree.update()
        
        sun.move(amount: CGFloat(accumulatedRotation) * 0.01)
        accumulatedRotation = 0
    }
}
