//
//  StairFootprint.swift
//
//  Created by Zack Brown on 05/12/2025.
//

import Deltille
import Newel

internal struct StairFootprint: HasTriangleFootprint {
    
    internal var origin: Triangle
    
    internal var footprint: Triangle.Footprint {
        
        .init(origin,
              stoop.footprint.tiles.map { $0.vertex.position })
    }
    
    internal var rotation: Triangle.Rotation?
    
    internal let stoop: Stoop
}
