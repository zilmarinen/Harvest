//
//  WaterTile.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import Lattice

public struct WaterTile: DataStoreValue {
    
    public typealias T = Triangle
    
    public let vertex: Triangle
    
    public let footprint: Set<Triangle>
    
    public let fluid: Fluid
}
