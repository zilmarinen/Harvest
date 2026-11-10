//
//  Water.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import Lattice

internal class Water: TileLattice<WaterChunk, WaterTile> {
    
    override func clean(_ chunk: WaterChunk,
                        _ sieve: Triangle.Sieve,
                        _ wedge: DataStoreWedge<Triangle, WaterTile>) -> Bool {
        
        false
    }
}
