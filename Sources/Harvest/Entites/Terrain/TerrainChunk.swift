//
//  TerrainChunk.swift
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import Euclid
import RealityKit

internal class TerrainChunk: TriangularEntity,
                             HasCollision,
                             HasModel,
                             HasSoilableComponent {
    
    internal init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .chunk)
    }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}
