//
//  Water.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import RealityKit

internal class Water: TriangularGrid<WaterRegion,
                                     WaterChunk,
                                     WaterTile> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.water.id
    }
}

extension Water {
 
    internal var dirtyRegions: [WaterRegion] {
        
        regions.filter { $0.isDirty }
    }
}
