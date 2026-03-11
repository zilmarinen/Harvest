//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Lattice

public struct WaterTile: TriangularDataStoreTile {
    
    public let origin: Triangle
    
    public let waterType: WaterType
    public let elevation: Int
}

extension WaterTile {
    
    public var footprint: Triangle.Footprint {
        
        .init(origin,
              [Coordinate.zero])
    }
    
    public var rotation: Triangle.Rotation? { nil }
}
