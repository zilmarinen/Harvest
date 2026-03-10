//
//  Buildings.swift
//
//  Created by Zack Brown on 10/11/2025.
//

import Deltille
import Lattice
import RealityKit

internal class Buildings: TriangularLattice<BuildingChunk, BuildingTile> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.buildings.id
    }
}
