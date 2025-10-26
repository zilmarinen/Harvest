//
//  WaterChunk.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Euclid
import RealityKit

internal class WaterChunk: TriangularEntity,
                           HasCollision,
                           HasModel,
                           HasSoilableComponent,
                           HasWaterComponent {
    
    internal init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .chunk)
    }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}
