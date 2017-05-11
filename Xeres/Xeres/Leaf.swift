//
//  Leaf.swift
//  Xeres
//
//  Created by Johan Moritz on 2017-04-26.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import SpriteKit

class Leaf: SKNode {
    
    private let shape: UIBezierPath
    private let shapeNode: SKShapeNode
    
    init(offset: CGPoint, direction: CGPoint) {
        shape = UIBezierPath()
        shapeNode = SKShapeNode()
        
        super.init()
        self.position = offset
        
        createPath(in: CGRect(x: 0, y: 0, width: 5, height: 5),
                   from: CGPoint(), inDirection: atan(direction.y / direction.x))
        shapeNode.path = shape.cgPath
        shapeNode.fillColor = UIColor(displayP3Red: 0.0, green: 150 / 255, blue: 50 / 255, alpha: 1.0)
        self.addChild(shapeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Creates a path to render the leaf ndoe
    // Angles goes clockwise as we're dealing with a left handed (?) coordinate system
    // Comment: The rotation and scale should be turned into CGAffineTransform matrices
    // to shorten the code vastly!
    func createPath(in bound: CGRect, from start: CGPoint, inDirection angle: CGFloat) {
        // This should be turned into something more flexible
        var from = CGPoint(x: 0,   y: 0)
        var to   = CGPoint(x: bound.maxX,   y: bound.maxY)
        var ctrl = CGPoint(x: (3 / 5) * bound.maxX, y: bound.maxY)
        
        // Sets angle=0 to mean "to the right"
        let rotationAngle = angle - CGFloat.pi / 4
        
        // Put the leaf into position, to calculate scale factors

        shape.move(to: CGPoint())
        shape.addQuadCurve(to: to, controlPoint: ctrl)
        shape.close()
        
        shape.apply(CGAffineTransform(rotationAngle: rotationAngle))
//        let translate = CGAffineTransform(translationX: start.x, y: start.y)
//        shape.apply(translate)
//        
//        // Calculate scale factors depending on draw direction from 'start'
//        
//        let box = shape.bounds
//        
//        let scaleFactor: CGFloat
//        let scaleFactX: CGFloat
//        let scaleFactY: CGFloat
//        
//        if box.maxX - 1 < start.x { // to the left
//            scaleFactX  = box.maxX  / box.width
//            
//            if box.maxY - 1 < start.y { // up
//                scaleFactY  = box.maxY / box.height
//            } else { // down
//                scaleFactY  = (bound.height-box.maxY) / box.height
//            }
//            
//        } else { // to the right
//            scaleFactX  = (bound.width-box.maxX)  / box.width
//            
//            if box.maxY - 1 < start.y { // up
//                scaleFactY  = box.maxY / box.height
//            } else { // down
//                scaleFactY  = (bound.height-box.maxY) / box.height
//            }
//        }
//        
//        scaleFactor = min(scaleFactX, scaleFactY)
//        
//        // Remake the shape of the leaf with correct scale
//        from = scale(from, from: from, by: scaleFactor)
//        to   = scale(to, from: from, by: scaleFactor)
//        ctrl = scale(ctrl, from: from, by: scaleFactor)
//        
//        shape.removeAllPoints()
//        shape.move(to: from)
//        shape.addQuadCurve(to: to, controlPoint: ctrl)
//        shape.close()
//        
//        shape.apply(translate)
    }
}
