//
//  Utilities.swift
//  Xeres
//
//  Created by Johan Moritz on 2017-04-28.
//  Copyright © 2017 wiemor. All rights reserved.
//
// A file for Xeres related utility functions – look here before writing your own :)

import Foundation
import UIKit


// *******************************************************
// ** CGFloat

func %(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
    return a.truncatingRemainder(dividingBy: b)
}

func rand(from: CGFloat, to: CGFloat) -> CGFloat {
    return ((to - from) * CGFloat(arc4random()) / CGFloat(UINT32_MAX)) + from
}

// *******************************************************



// *******************************************************
// ** CGPoint
// **
// *********  Operators *********

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


// ********* Functions *********

func normalize(_ point: CGPoint) -> CGPoint {
    return point / sqrt(pow(point.x, 2) + pow(point.y, 2))
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

func flip(_ point: CGPoint, inRect: CGRect) -> CGPoint {
    return CGPoint(x: point.x, y: inRect.maxY - point.y)
}



// *******************************************************
