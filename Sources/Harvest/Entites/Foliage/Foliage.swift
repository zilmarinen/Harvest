//
//  Foliage.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import Lattice
import RealityKit

internal class Foliage: TriangularLattice<FoliageChunk, FoliageTile> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.foliage.id
    }
}
