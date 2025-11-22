//
//  Edifices.swift
//
//  Created by Zack Brown on 10/11/2025.
//

import Deltille
import RealityKit

internal class Edifices: TriangularGridDataSource<EdificeRegion,
                                                  EdificeChunk,
                                                  Triangle.Septomino> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.edifices.id
    }
}
