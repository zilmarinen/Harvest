//
//  Stairs.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import Newel
import RealityKit

internal class Stairs: TriangularGrid<StairRegion,
                                      StairChunk,
                                      Stoop> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.stairs.id
    }
}

extension Stairs {
 
    internal var dirtyRegions: [StairRegion] {
        
        regions.filter { $0.isDirty }
    }
}
