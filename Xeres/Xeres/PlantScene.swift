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
    }
    
    override func didMove(to view: SKView) {
        PlantScene.scene = self
        //self.tree = Tree(scene: self)
        
        self.sun = Sun(position: CGPoint(x: frame.midX, y: frame.midY),
                       minWidth: frame.minX,
                       maxWidth: frame.maxX)
        addChild(sun)
        
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
        //self.removeAllChildren()
        
        //tree.grow(from: CGPoint(x: frame.midX, y: frame.minY))
        
        //tree.update()
        
        sun.move(force: CGFloat(accumulatedRotation))
        accumulatedRotation = 0
    }
}
