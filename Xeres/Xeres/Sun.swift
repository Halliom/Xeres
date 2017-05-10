//
//  Sun.swift
//  Xeres
//
//  Created by Johan Wieslander on 2017-05-10.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import SpriteKit

class Sun: SKNode {
    
    let minWidth: CGFloat
    let maxWidth: CGFloat
    
    init(position: CGPoint, minWidth: CGFloat, maxWidth: CGFloat) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        
        super.init()
        
        self.position = position
        updateRenderInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(force: CGFloat) {
        let newPos = self.position.x + force
        self.position.x = max(minWidth, min(maxWidth, newPos))
    }
    
    func updateRenderInfo() {
        var shapeNode = SKShapeNode(circleOfRadius: 175)
        shapeNode.fillColor = UIColor.yellow
        shapeNode.strokeColor = UIColor.white
        shapeNode.position = self.position
        
        self.addChild(shapeNode)
    }
}
