//
//  Terrain.swift
//
//  Created by Zack Brown on 10/08/2025.
//

import Deltille
import RealityKit

internal class Terrain: TriangularGrid<TerrainRegion,
                                       TerrainChunk,
                                       Triangle> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.terrain.id
    }
}

extension Terrain {
 
    internal var dirtyRegions: [TerrainRegion] {
        
        regions.filter { $0.isDirty }
    }
}
