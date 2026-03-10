//
//  Terrain.swift
//
//  Created by Zack Brown on 10/08/2025.
//

import Deltille
import Lattice
import RealityKit

internal class Terrain: HexagonalLattice<TerrainChunk, TerrainVertex> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.terrain.id
    }
}
