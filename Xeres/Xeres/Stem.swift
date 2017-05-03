//
//  Stem.swift
//  Xeres
//
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit

class Stem {
    
    let path: UIBezierPath
    
    let direction: CGPoint
    
    private var oldLength: CGFloat
    
    init(dir: CGPoint) {
        path = UIBezierPath()
        direction = dir
        oldLength = 0
    }
    
    func draw(_ position: CGPoint, length: CGFloat) -> CGPoint {
        
    }
}
