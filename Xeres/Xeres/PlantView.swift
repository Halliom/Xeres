//
//  PlantView.swift
//  Xeres
//
//  Copyright © 2017 wiemor. All rights reserved.
//

import Foundation
import UIKit

fileprivate func paintOver(_ rect: CGRect) {
    let filler = UIBezierPath()
    
    filler.move(to: CGPoint(x: rect.minX , y: rect.minY))
    filler.addLine(to: CGPoint(x: rect.maxX , y: rect.minY))
    filler.addLine(to: CGPoint(x: rect.maxX , y: rect.maxY))
    filler.addLine(to: CGPoint(x: rect.minX , y: rect.maxY))
    filler.close()
    
    let col = UIColor.white
    col.setFill()
    filler.fill()
}

class PlantView: UIView {
    
    let tree = Tree()
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
  
    
    override func draw(_ rect: CGRect) {
        
        tree.grow(from: CGPoint(x: rect.midX, y: rect.maxY))
        
        tree.draw()
        paintOver(rect)
        tree.draw()
        paintOver(rect)
        tree.draw()
        paintOver(rect)
        tree.draw()
        paintOver(rect)
        tree.draw()
        paintOver(rect)
        tree.draw()
        paintOver(rect)
        tree.draw()
        paintOver(rect)
        tree.draw()
        paintOver(rect)
        tree.draw()
        
     
    }
}
