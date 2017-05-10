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
    
    let radius: CGFloat = 50;
    
    // Suns path, going in a curve
    let start: CGPoint
    let top: CGPoint
    let end: CGPoint
    var pathProgress: CGFloat
    
    init(position: CGPoint, topOfScreen: CGFloat, minWidth: CGFloat, maxWidth: CGFloat) {
        self.start = CGPoint(x: minWidth, y: topOfScreen - radius)
        self.top = CGPoint(x: (minWidth + maxWidth) / 2, y: topOfScreen)
        self.end = CGPoint(x: maxWidth, y: topOfScreen - radius)
        self.pathProgress = 0.5
        
        super.init()
        
        move(amount: 0)
        updateRenderInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(amount: CGFloat) {
        pathProgress += amount
        
        if pathProgress > 1.0 {
            pathProgress = 1.0
        } else if pathProgress < 0.0 {
            pathProgress = 0.0
        }
        
        self.position = quadraticBezier(from: start, to: end, controlPoint: top, fraction: pathProgress)
    }
    
    func updateRenderInfo() {
        var shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode.fillColor = UIColor.yellow
        shapeNode.strokeColor = UIColor.white
        shapeNode.position = self.position
        
        self.addChild(shapeNode)
    }
}
