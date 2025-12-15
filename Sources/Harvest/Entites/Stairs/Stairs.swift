//
//  Stairs.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import Newel
import RealityKit

internal class Stairs: TriangularFootprintDataStore<StairChunk, StairFootprint> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.stairs.id
    }
}
