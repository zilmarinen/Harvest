//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Lattice

public struct WaterTile: TriangularDataStoreTile {
    
    public let coord: Coordinate
    
    public let rotation: Triangle.Rotation
    
    public let waterType: WaterType
    public let elevation: Int
}

extension WaterTile {
    
    public var footprint: [Coordinate] { [coord] }
}
