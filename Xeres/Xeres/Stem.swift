//
//  Stem.swift
//  Xeres
//
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit

class Stem {
    
    var path: UIBezierPath
    
    let direction: CGPoint
    
    private var length: CGFloat
    private var start: CGPoint
    private var end: CGPoint
    private var bezierDirection: CGPoint
    
    init(dir: CGPoint) {
        path = UIBezierPath()
        direction = dir
        
        length = 0
        start = CGPoint(x: 0, y: 0)
        end = CGPoint(x: 0, y: 0)
        
        let rand = 0.15 * CGFloat(arc4random()) / CGFloat(Int32.max)
        bezierDirection = CGPoint(x: rand * dir.x, y: (1.0 - rand) * dir.y) * 0.7
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
        
        let lerp1 = (controlPoint - start) * (1.0 - fraction)
        let lerp2 = (controlPoint - end) * fraction
        
        return lerp1 + lerp2
    }
    
    func getTopPoint() -> CGPoint {
        return end
    }
    
    func draw(_ position: CGPoint, length: CGFloat) {
        if length != self.length || position != start {
            // Set new positions & length
            start = position
            end = position + (direction * length)
            self.length = length
            
            updatePath()
        }
        
        path.stroke()
    }
}
