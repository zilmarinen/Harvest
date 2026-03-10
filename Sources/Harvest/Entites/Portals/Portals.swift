//
//  Portals.swift
//  Harvest
//
//  Created by Zack Brown on 14/02/2026.
//

import Deltille
import Lattice
import RealityKit

internal class Portals: TriangularLattice<PortalChunk, PortalTile> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.portals.id
    }
}
