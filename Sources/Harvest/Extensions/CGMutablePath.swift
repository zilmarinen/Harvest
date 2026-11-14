//
//  CGMutablePath.swift
//  Harvest
//
//  Created by Zack Brown on 14/11/2026.
//

import CoreGraphics
import Euclid

public extension CGMutablePath {
    
    func addLine(to vector: Vector) {
        
        addLine(to: .init(x: vector.x,
                          y: vector.z))
    }
    
    func move(to vector: Vector) {
        
        move(to: .init(x: vector.x,
                       y: vector.z))
    }
}
