//
//  Staircases.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import Newel
import RealityKit

internal class Staircases: TriangularFootprintDataStore<StaircaseChunk, StaircaseFootprint> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.staircases.id
    }
}
