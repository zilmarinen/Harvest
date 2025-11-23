//
//  Biosphere.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille
import RealityKit

internal class Biosphere: HexagonalGridDataSource<BiomeVertex> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.biosphere.id
    }
}
