//
//  PlantScene.swift
//  Xeres
//
//  Copyright © 2017 wiemor. All rights reserved.

import Foundation
import SpriteKit

class PlantScene: SKScene {
    
    static var scene: PlantScene!
    
    var tree: Tree!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        PlantScene.scene = self
        tree = Tree(scene: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        tree.grow(from: CGPoint(x: frame.midX, y: frame.minY))
        
        tree.update()
    }
}
