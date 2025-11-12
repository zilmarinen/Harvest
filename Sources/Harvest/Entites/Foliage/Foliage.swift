//
//  Foliage.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class Foliage: TriangularGrid<FoliageRegion,
                                       FoliageChunk,
                                       Triangle> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.foliage.id
    }
}

extension Foliage {
 
    internal var dirtyRegions: [FoliageRegion] {
        
        regions.filter { $0.isDirty }
    }
}

extension Foliage {
    
    internal func propagate(vertex: Triangle.Vertex) {
        
        for triangle in vertex.tiles {
            
            guard let chunk = chunk(for: triangle) else { return }
            
            chunk.becomeDirty()
        }
    }
}
