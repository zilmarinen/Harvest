//
//  Footpaths.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import Deltille
import Lattice
import RealityKit

internal class Footpaths: HexagonalLattice<FootpathChunk, FootpathType> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.footpaths.id
    }
}
