//
//  PortalTile.swift
//  Harvest
//
//  Created by Zack Brown on 14/02/2026.
//

import Deltille
import Lattice

public struct PortalTile: TriangularDataStoreTile {
    
    public let origin: Triangle.Vertex
}

extension PortalTile {
    
    public var footprint: Triangle.Footprint {
        
        .init(.init(origin),
              [Coordinate.zero])
    }
    
    public var rotation: Triangle.Rotation? { nil }
}
