//
//  FoliageRegion.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class FoliageRegion: TriangularRegion<FoliageChunk>,
                              HasSoilableComponent {
    
    internal override init(_ triangle: Triangle) {
        
        super.init(triangle)
    }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

extension FoliageRegion {
 
    internal var dirtyChunks: [FoliageChunk] {
        
        chunks.filter { $0.isDirty }
    }
}

extension FoliageRegion {
    
    internal func set(foliage triangle: Triangle) {
        
        let parent = triangle.transpose(.tile,
                                        .chunk)
        
        let chunk = chunk(for: parent) ?? .init(parent)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(foliage: triangle)
        
        chunk.becomeDirty()
    }
}
