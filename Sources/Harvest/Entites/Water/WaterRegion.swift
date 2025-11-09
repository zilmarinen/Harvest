//
//  WaterRegion.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class WaterRegion: TriangularRegion<WaterChunk>,
                            HasSoilableComponent {
    
    internal override init(_ triangle: Triangle) {
        
        super.init(triangle)
    }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

extension WaterRegion {
 
    internal var dirtyChunks: [WaterChunk] {
        
        chunks.filter { $0.isDirty }
    }
}

extension WaterRegion {
    
    internal func get(tile triangle: Triangle) -> WaterTile? {
     
        guard let chunk = chunk(for: triangle) else { return nil }
        
        return chunk.get(tile: triangle)
    }
    
    internal func set(_ waterType: WaterType,
                      _ elevation: Int,
                      for triangle: Triangle) {
        
        let chunk = chunk(for: triangle) ?? .init(triangle.transpose(.tile,
                                                                     .chunk))
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(waterType,
                  elevation,
                  for: triangle)
        
        chunk.becomeDirty()
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
}
