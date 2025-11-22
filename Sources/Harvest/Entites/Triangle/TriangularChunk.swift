//
//  TriangularChunk.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class TriangularChunk: TriangularEntity,
                              HasSoilableComponent {
    
    required internal init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .chunk)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}
