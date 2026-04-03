//
//  Water.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Lattice
import RealityKit

internal class Water: TriangularLattice<WaterChunk, WaterTile> {
    
    internal static func apex(for elevation: Int) -> Double {
        
        Terrain.base(for: elevation) - Terrain.Constant.apexHeight
    }
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.water.id
    }
}
