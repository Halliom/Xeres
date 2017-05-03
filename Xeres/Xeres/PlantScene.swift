//
//  PlantScene.swift
//  Xeres
//
//  Created by Johan Wieslander on 2017-05-03.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import SpriteKit

class PlantScene: SKScene {
    
    static var scene: PlantScene!
    
    let tree = Tree()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        PlantScene.scene = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.removeAllChildren()
        
        tree.grow(from: CGPoint(x: frame.midX, y: frame.minY))
        
        tree.draw()
    }
}
