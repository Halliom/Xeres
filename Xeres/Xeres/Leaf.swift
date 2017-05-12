//
//  Leaf.swift
//  Xeres
//
//  Created by Johan Moritz on 2017-04-26.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import SpriteKit

fileprivate let SIZE = 20

class Leaf: SKNode {
    
    private let shape: UIBezierPath
    private let shapeNode: SKShapeNode
    
    init(offset: CGPoint, direction: CGPoint) {
        shape = UIBezierPath()
        shapeNode = SKShapeNode()
        
        super.init()
        // Moves coordinate system
        self.position = offset
        
        createPath(inDirection: atan(direction.y / direction.x))
        shapeNode.path = shape.cgPath
        shapeNode.fillColor = UIColor(displayP3Red: 0.0, green: 150 / 255, blue: 50 / 255, alpha: 1.0)
        self.addChild(shapeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPath(inDirection angle: CGFloat) {
        
        let start  = CGPoint(x: 0, y: 0)
        
        let mid   = CGPoint(x: SIZE, y: SIZE)
        let ctrl1 = CGPoint(x: (3 / 5) * SIZE, y: SIZE)
        
        let end   = CGPoint(x: 0, y: 0)
        let ctrl2 = CGPoint(x: (2 / 5) * SIZE, y: (2/5) * SIZE)
        
        // Sets angle=0 to mean "to the right"
        let rotationAngle = angle - CGFloat.pi / 4
        

        shape.move(to: start)
        shape.addQuadCurve(to: mid, controlPoint: ctrl1)
        //shape.addQuadCurve(to: end, controlPoint: ctrl2)
        shape.close()
        
        // Put the leaf into position
        shape.apply(CGAffineTransform(rotationAngle: rotationAngle))
    }
}
