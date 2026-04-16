//
//  Slopes.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import Lattice
import Newel
import RealityKit

internal class Slopes: TriangularLattice<SlopeChunk, SlopeTile> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.slopes.id
    }
}
