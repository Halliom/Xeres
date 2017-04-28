//
//  Leaf.swift
//  Xeres
//
//  Created by Johan Moritz on 2017-04-26.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit


func -(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    return CGPoint(x: b.x - a.x, y: b.y - a.y)
}

func %(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
    return a.truncatingRemainder(dividingBy: b)
}

func +(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    return CGPoint(x: a.x + b.x, y: a.y + b.y)
}

func rotateAroundOrigin(_ p: CGPoint, withAngle radians: CGFloat) -> CGPoint {
    let x = p.x*cos(radians) - p.y*sin(radians)
    let y = p.y*cos(radians) + p.x*sin(radians)
    return CGPoint(x: x, y: y)
    
}

func scale(_ p: CGPoint, from origin: CGPoint, by factor: CGFloat) -> CGPoint {
    let diff = origin - p
    return CGPoint(x: origin.x + diff.x*factor, y: origin.y + diff.y*factor)
    
}


class Leaf {
    
    
    private let shape = UIBezierPath()
    
    
    // Draws a leaf on the current drawing context
    // Angles goes clockwise as we're dealing with a left handed (?) coordinate system
    // Comment: The rotation and scale should be turned into CGAffineTransform matrices
    // to shorten the code vastly!
    func draw(in bound: CGRect, from start: CGPoint, inDirection angle: CGFloat) {
        
        // This should be turned into something more flexible
        var from = CGPoint(x: 0,   y: 0)
        var to   = CGPoint(x: 1,   y: 1)
        var ctrl = CGPoint(x: 4/5, y: 1)
        
        // Sets angle=0 to mean "to the right"
        let rotationAngle = angle - CGFloat.pi/4
        
        
        
        // Put the leaf into position, to calculate scale factors
        from = rotateAroundOrigin(from, withAngle: rotationAngle)
        to   = rotateAroundOrigin(to, withAngle: rotationAngle)
        ctrl = rotateAroundOrigin(ctrl, withAngle: rotationAngle)

        shape.move(to: from)
        shape.addQuadCurve(to: to, controlPoint: ctrl)
        shape.close()
        
        let translate = CGAffineTransform(translationX: start.x, y: start.y)
        shape.apply(translate)
        
        
        
        // Calculate scale factors depending on draw direction from 'start'
        
        let box = shape.bounds
        
        let scaleFactor : CGFloat
        let scaleFactX  : CGFloat
        let scaleFactY  : CGFloat
    
        
        if box.maxX - 1 < start.x { // to the left
            scaleFactX  = box.maxX  / box.width
            
            if box.maxY - 1 < start.y { // up
                scaleFactY  = box.maxY / box.height
            } else { // down
                scaleFactY  = (bound.height-box.maxY) / box.height
            }
            
        } else { // to the right
            scaleFactX  = (bound.width-box.maxX)  / box.width
            
            if box.maxY - 1 < start.y { // up
                scaleFactY  = box.maxY / box.height
            } else { // down
                scaleFactY  = (bound.height-box.maxY) / box.height
            }
        }
        
        scaleFactor = min(scaleFactX, scaleFactY)
        
        
        
        
        // Remake the shape of the leaf with correct scale
        from = scale(from, from: from, by: scaleFactor)
        to   = scale(to, from: from, by: scaleFactor)
        ctrl = scale(ctrl, from: from, by: scaleFactor)
        
        shape.removeAllPoints()
        shape.move(to: from)
        shape.addQuadCurve(to: to, controlPoint: ctrl)
        shape.close()
        
        shape.apply(translate)
        
        // Draw leaf
        let color = UIColor.red
        color.setFill()
        shape.fill()
        
    }
    
}
