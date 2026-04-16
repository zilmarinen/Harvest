//
//  BuildingTile.swift
//
//  Created by Zack Brown on 14/12/2025.
//

import Bivouac
import Deltille
import Lattice

public struct BuildingTile: TriangularDataStoreTile {
    
    public let origin: Triangle.Vertex
    
    public let rotation: Triangle.Rotation
    
    public let septomino: Triangle.Septomino
}

extension BuildingTile {
    
    public var footprint: Triangle.Footprint {
        
        .init(.init(origin),
              septomino.coordinates)
    }
}
