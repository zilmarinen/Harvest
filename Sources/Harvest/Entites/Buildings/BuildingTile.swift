//
//  BuildingTile.swift
//
//  Created by Zack Brown on 14/12/2025.
//

import Bivouac
import Deltille
import Lattice

public struct BuildingTile: TriangularDataStoreTile {
    
    public let coord: Coordinate
    
    public let rotation: Triangle.Rotation
    
    public let septomino: Triangle.Septomino
}

extension BuildingTile {
    
    public var footprint: [Coordinate] {
        //TODO: Fix horrible rotation logic
        let value = Triangle.Footprint(.init(coord),
                                       septomino.coordinates)
        
        guard rotation != .identity else { return value.tiles.map { $0.vertex.position } }
        
        return value.rotate(rotation).tiles.map { $0.vertex.position }
    }
}
