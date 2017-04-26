//
//  Stem.swift
//  Xeres
//
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit

func +(point: CGPoint, f: CGFloat) -> CGPoint {
    return CGPoint(x: point.x + f, y: point.y + f)
}

func +(point1: CGPoint, point2: CGPoint) -> CGPoint {
    return CGPoint(x: point1.x + point2.x, y: point1.y + point2.y)
}

func -(point: CGPoint, f: CGFloat) -> CGPoint {
    return CGPoint(x: point.x - f, y: point.y - f)
}

func -(point1: CGPoint, point2: CGPoint) -> CGPoint {
    return CGPoint(x: point1.x - point2.x, y: point1.y - point2.y)
}

func *(point: CGPoint, f: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * f, y: point.y * f)
}

func /(point: CGPoint, f: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / f, y: point.y / f)
}

func normalize(_ point: CGPoint) -> CGPoint {
    return point / sqrt(pow(point.x, 2) + pow(point.y, 2))
}

class StemPoint {
    
    let size: CGFloat
    
    let position: CGPoint
    
    init(size: CGFloat, position: CGPoint) {
        self.size = size
        self.position = position
    }
}

class Stem {
    
    let path: UIBezierPath
    
    let start: CGPoint
    
    var connectionPoint: (CGPoint, CGPoint)
    
    init(startingPoint: CGPoint) {
        path = UIBezierPath()
        start = startingPoint
        connectionPoint = (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
    }
    
    func flip(_ point: CGPoint, inRect: CGRect) -> CGPoint {
        return CGPoint(x: point.x, y: inRect.maxY - point.y)
    }
    
    func rand(from: CGFloat, to: CGFloat) -> CGFloat {
        return ((to - from) * CGFloat(arc4random()) / CGFloat(UINT32_MAX)) + from
    }
    
    func drawSegment(to: StemPoint, rect: CGRect) {
        let from = (connectionPoint.0 + connectionPoint.1) / 2.0
        
        let direction = to.position - from
        let normal = normalize(CGPoint(x: -direction.y, y: direction.x))
    
        let control1 = CGPoint(x: from.x + (direction.x * rand(from: 0.1, to:0.2)),
                               y: from.y + (direction.y * rand(from: 0.75, to:1.0)))
        let control2 = to.position - (direction * 0.5)
        
        let toOffset = normal * to.size
        
        // Move to starting position from.position - from.size
        path.move(to: flip(connectionPoint.0, inRect: rect))
        
        // Add bezier curve to the end point (to.position - to.size)
        path.addCurve(to:             flip(to.position + toOffset, inRect: rect),
                      controlPoint1:  flip(control1 + toOffset, inRect: rect),
                      controlPoint2:  flip(control2 + toOffset, inRect: rect))
        
        // Move to the other side of the end point  (to.position + to.size)
        path.addLine(to: flip(to.position - toOffset, inRect: rect))
        
        // Draw back to the start (other side of the start) and reverse the order of
        // the control points since we are drawing the other from "to" to "from"
        path.addCurve(to:             flip(connectionPoint.1, inRect: rect),
                      controlPoint1:  flip(control2 - toOffset, inRect: rect),
                      controlPoint2:  flip(control1 - toOffset, inRect: rect))
        
        // Move back to the start to close the path
        path.close()
        
        UIColor.green.setFill()
        path.stroke()
        
        // Update connectionPoint in preparation for the next call
        connectionPoint = (to.position + toOffset, to.position - toOffset)
    }
    
    func drawStartSegment(from: StemPoint, to: StemPoint, rect: CGRect) {
        let direction = to.position - from.position
        let normal = normalize(CGPoint(x: -direction.y, y: direction.x))
        let fromOffset = normal * from.size
        
        self.connectionPoint = (from.position + fromOffset, from.position - fromOffset)
        
        drawSegment(to: to, rect: rect)
    }
    
    func draw(_ rect: CGRect) {
        let angle1 = CGFloat.pi / 6.0
        let length1 = CGFloat(150)
        let point1 = CGPoint(x: start.x + length1 * cos(angle1), y: start.y + length1 * sin(angle1))
        
        drawStartSegment(from: StemPoint(size: 20.0, position: start + 30),
                         to: StemPoint(size: 10.0, position: point1),
                         rect: rect)
        
        let angle2 = CGFloat.pi / 4.0
        let length2 = CGFloat(100)
        let point2 = CGPoint(x: point1.x + length2 * cos(angle2), y: point1.y + length2 * sin(angle2))
        drawSegment(to: StemPoint(size: 5.0, position: point2),
                    rect: rect)
    }
}
