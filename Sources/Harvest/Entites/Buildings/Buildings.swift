//
//  Buildings.swift
//
//  Created by Zack Brown on 10/11/2025.
//

import Deltille
import RealityKit

internal class Buildings: TriangularFootprintDataStore<BuildingChunk, BuildingFootprint> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.buildings.id
    }
}
