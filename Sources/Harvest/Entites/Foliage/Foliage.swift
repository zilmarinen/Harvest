//
//  Foliage.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import RealityKit

internal class Foliage: TriangularDataStore<FoliageChunk, Triangle> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.foliage.id
    }
}
