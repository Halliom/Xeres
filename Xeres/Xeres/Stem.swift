//
//  Stem.swift
//  Xeres
//
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Stem: SKNode {
    
    var path: UIBezierPath
    
    let direction: CGPoint
    
    private var length: CGFloat
    private let start: CGPoint
    private var end: CGPoint
    private var bezierDirection: CGPoint
    private let shapeNode: SKShapeNode
    
    init(dir: CGPoint) {
        path = UIBezierPath()
        direction = dir
        
        length = 0
        start = CGPoint(x: 0, y: 0)
        end = CGPoint(x: 0, y: 0)
        
        let rand = 0.15 * CGFloat(arc4random()) / CGFloat(Int32.max)
        bezierDirection = CGPoint(x: rand * dir.x, y: (1.0 - rand) * dir.y) * 0.7
        
        shapeNode = SKShapeNode(path: path.cgPath)
        
        super.init()
        
        self.addChild(shapeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePath() {
        let controlPoint = start + (bezierDirection * length)
        
        path = UIBezierPath()
        path.lineWidth = 3.0
        
        path.move(to: start)
        path.addQuadCurve(to: end, controlPoint: controlPoint)
    }
    
    func getPointOnStem(fraction: CGFloat) -> CGPoint {
        let controlPoint = start + (bezierDirection * length)
        
        let lerp1 = (1-fraction)*(1-fraction)*start
        let lerp2 = 2*(1-fraction)*fraction*controlPoint
        let lerp3 = fraction*fraction * end
        
        return lerp1 + lerp2 + lerp3
    }
    
    func getTopPoint() -> CGPoint {
        return end
    }
    
    func update(length: CGFloat) {
        if length != self.length {
            // Set new positions & length
            end = position + (direction * length)
            self.length = length
            
            updatePath()
        }
        shapeNode.path = path.cgPath
    }
}
