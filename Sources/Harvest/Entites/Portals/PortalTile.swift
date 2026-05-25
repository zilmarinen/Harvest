//
//  PortalTile.swift
//  Harvest
//
//  Created by Zack Brown on 14/02/2026.
//

import Deltille
import Lattice

public struct PortalTile: TriangularDataStoreTile {
    
    public let vertex: Triangle.Vertex
    
    public let rotation: Triangle.Rotation
}

extension PortalTile {
    
    public var footprint: [Triangle.Vertex] { [vertex] }
}
