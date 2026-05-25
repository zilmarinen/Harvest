//
//  BuildingTile.swift
//
//  Created by Zack Brown on 14/12/2025.
//

import Bivouac
import Deltille
import Lattice

public struct BuildingTile: TriangularDataStoreTile {
    
    public let vertex: Triangle.Vertex
    
    public let rotation: Triangle.Rotation
    
    public let septomino: Triangle.Septomino
}

extension BuildingTile {
    
    public var footprint: [Triangle.Vertex] {
        //TODO: Fix horrible rotation logic
        let value = Triangle.Footprint(.init(vertex),
                                       septomino.coordinates)
        
        guard rotation != .identity else { return value.tiles.map { $0.vertex} }
        
        return value.rotate(rotation).tiles.map { $0.vertex }
    }
}
