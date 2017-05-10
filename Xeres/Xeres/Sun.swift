//
//  Sun.swift
//  Xeres
//
//  Created by Johan Wieslander on 2017-05-10.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import SpriteKit

/**
 * Class for rendering a big glowing sun in the sky.
 */
class Sun: SKNode {
    
    // The radius of the sun
    let radius: CGFloat = 40;
    
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
    
    /**
     * Returns the (normalised) direction to the sun from the given point.
     */
    func getDirectionToSun(from: CGPoint) -> CGPoint {
        return normalize(self.position - from)
    }
    
    /**
     * Moves the sun a given amount. Increments the progress variable
     * which ranges from 0 to 1 where 0 is all to the left side and 1
     * is all to the right side.
     */
    func move(amount: CGFloat) {
        pathProgress += amount
        
        if pathProgress > 1.0 {
            pathProgress = 1.0
        } else if pathProgress < 0.0 {
            pathProgress = 0.0
        }
        
        self.position = quadraticBezier(from: start, to: end, controlPoint: top, fraction: pathProgress)
    }
    
    /**
     * Updates the render info for the sun.
     */
    func createRenderInfo() {
        var shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode.fillColor = UIColor(red: 1.0, green: 207 / 255, blue: 90 / 255, alpha: 1.0)
        
        shapeNode.strokeColor = UIColor(red: 1.0, green: 213 / 255, blue: 110 / 255, alpha: 1.0)
        shapeNode.glowWidth = 20
        
        shapeNode.position = self.position
        
        self.addChild(shapeNode)
    }
}
