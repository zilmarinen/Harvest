//
//  BuildingTile.swift
//
//  Created by Zack Brown on 14/12/2025.
//

import Deltille

public struct BuildingTile: HasTriangleFootprint {
    
    internal var origin: Triangle
    
    internal var footprint: Triangle.Footprint {
        
        .init(origin,
              septomino.coordinates)
    }
    
    internal var rotation: Triangle.Rotation?
    
    internal let septomino: Triangle.Septomino
}
