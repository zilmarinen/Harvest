//
//  SlopeTile.swift
//
//  Created by Zack Brown on 05/12/2025.
//

import Deltille
import Lattice
import Newel

public struct SlopeTile: TriangularDataStoreTile {
    
    public let coord: Coordinate
    
    public let rotation: Triangle.Rotation
    
    public let slope: Slope
    public let rise: Rise
    public let cast: Cast
}

extension SlopeTile {
    
    public var footprint: [Coordinate] {
        //TODO: Fix horrible rotation logic
        let value = Triangle.Footprint(.init(coord),
                                       slope.coordinates)
        
        guard rotation != .identity else { return value.tiles.map { $0.vertex.position } }
        
        return value.rotate(rotation).tiles.map { $0.vertex.position }
    }
}
