//
//  SlopeTile.swift
//
//  Created by Zack Brown on 05/12/2025.
//

import Deltille
import Lattice
import Newel

public struct SlopeTile: TriangularDataStoreTile {
    
    public let origin: Triangle.Vertex
    
    public let rotation: Triangle.Rotation
    
    public let slope: Slope
    public let rise: Rise
    public let cast: Cast
}

extension SlopeTile {
    
    public var footprint: Triangle.Footprint {
        
        let value = Triangle.Footprint(.init(origin),
                                       slope.coordinates)
        
        guard rotation != .identity else { return value }
        
        return value.rotate(rotation)
    }
}
