//
//  PortalTile.swift
//  Harvest
//
//  Created by Zack Brown on 14/02/2026.
//

import Deltille
import Lattice

public struct PortalTile: TriangularDataStoreTile {
    
    public let coord: Coordinate
    
    public let rotation: Triangle.Rotation
}

extension PortalTile {
    
    public var footprint: [Coordinate] { [coord] }
}
