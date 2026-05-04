//
//  Fences.swift
//  Harvest
//
//  Created by Zack Brown on 03/05/2026.
//

import Deltille
import Lattice
import RealityKit

internal class Fences: HexagonalLattice<FenceChunk, FenceVertex> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.fences.id
    }
}
