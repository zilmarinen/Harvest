//
//  WaterTile.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import Lattice

internal struct WaterTile: DataStoreValue {
    
    internal typealias T = Triangle
    
    internal let vertex: Triangle
    
    internal let footprint: Set<Triangle>
    
    internal let fluid: Fluid
}
