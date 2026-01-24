//
//  SIMD.swift
//  Harvest
//
//  Created by Zack Brown on 24/01/2026.
//

import Euclid
import RealityKit

extension float4x4 {
    
    internal var forward: Vector {
        
        Vector(Double(-columns.2.x),
               Double(-columns.2.y),
               Double(-columns.2.z)).normalized()
    }
    
    internal var right: Vector {
        
        Vector(Double(columns.0.x),
               Double(columns.0.y),
               Double(columns.0.z)).normalized()
    }
}
