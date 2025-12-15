//
//  Edifices.swift
//
//  Created by Zack Brown on 10/11/2025.
//

import Deltille
import RealityKit

internal class Edifices: TriangularFootprintDataStore<EdificeChunk, EdificeFootprint> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.edifices.id
    }
}
