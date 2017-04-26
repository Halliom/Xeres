//
//  Leaf.swift
//  Xeres
//
//  Created by Johan Moritz on 2017-04-26.
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit

class Leaf {
    
    private let shape = UIBezierPath()
    private var bound = CGRect()
    
    // Draws a leaf on the current drawing context
    func draw(bound: CGRect, start: CGPoint) {
        self.bound = bound
        
        shape.move(to: start)
        shape.addQuadCurve(to: offset(fracX: 2/3, fracY: 1/2) , controlPoint: offset(fracX: 1/3, fracY: 1/2))
        shape.addQuadCurve(to:  start, controlPoint: offset(fracX: 1/2, fracY: 1/3))
        shape.close()
        
        let color = UIColor.red
        color.setFill()
        shape.fill()
        
    }
    
    // Returns the point in global coordinates corresponding to 
    // fractions of the way between minX and maxX, as well as 
    // between minY and maxY
    private func offset(fracX: CGFloat, fracY: CGFloat) -> CGPoint {
        let x = bound.minX + bound.width*fracX
        let y = bound.minX + bound.height*fracY
        return CGPoint(x: x, y: y)
    }
    
}
