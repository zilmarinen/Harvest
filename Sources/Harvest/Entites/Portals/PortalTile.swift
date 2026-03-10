//
//  PortalTile.swift
//  Harvest
//
//  Created by Zack Brown on 14/02/2026.
//

import Deltille
import Lattice

public struct PortalTile: HasFootprint {
    
    public let origin: Triangle
}

extension PortalTile {
    
    public var footprint: Triangle.Footprint {
        
        .init(origin,
              [Triangle.zero])
    }
    
    public var rotation: Triangle.Rotation? { nil }
}
