//
//  TriangularRegionDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class TriangularRegionDataSource<C: TriangularChunkDataSource<V>,
                                        V: Codable>: TriangularRegion<C>,
                                                     GridRegionDataSource {
    
    internal func merge(_ chunk: C) {
        
        let match = chunk.triangle.transpose(.chunk,
                                             .tile)
        
        guard let existing = self.chunk(for: match) else {
            
            return addChild(chunk)
        }
        
        existing.merge(chunk.dataSource)
    }
    
    internal func value(for key: Triangle) -> V? {
        
        guard let chunk = chunk(for: key) else { return nil }
        
        return chunk.value(for: key)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle) {
        
        let chunk = chunk(for: key) ?? .init(key.transpose(.tile,
                                                           .chunk))
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(value,
                  for: key)
        
        becomeDirty()
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
}
