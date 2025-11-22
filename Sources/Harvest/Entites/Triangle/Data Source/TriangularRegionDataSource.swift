//
//  TriangularRegionDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class TriangularRegionDataSource<C: TriangularChunkDataSource<T>,
                                        T: Codable>: TriangularRegion<C> {}

extension TriangularRegionDataSource {
    
    internal func value(for tile: Triangle) -> T? {
        
        guard let chunk = chunk(for: tile) else { return nil }
        
        return chunk.value(for: tile)
    }
    
    internal func set(_ value: T?,
                      for tile: Triangle) {
        
        let chunk = chunk(for: tile) ?? .init(tile.transpose(.tile,
                                                             .chunk))
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(value,
                  for: tile)
        
        becomeDirty()
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
}
