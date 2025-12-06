//
//  Water.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import RealityKit

internal class Water: TriangularDataStore<WaterChunk, WaterTile> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.water.id
    }
}
