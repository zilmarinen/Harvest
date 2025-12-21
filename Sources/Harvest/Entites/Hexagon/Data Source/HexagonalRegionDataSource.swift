//
//  HexagonalRegionDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class HexagonalRegionDataSource<C: HexagonalChunkDataSource<V>,
                                       V: Codable>: HexagonalRegion<C>,
                                                    GridRegionDataSource {
    
    internal func merge(_ chunk: C) {
        
        guard let existing = self.chunk(for: chunk.hexagon) else {
        
            return addChild(chunk)
        }
        
        existing.merge(chunk.dataSource)
    }
    
    internal func value(for key: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon) else { return nil }
        
        return chunk.value(for: key)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle.Vertex) {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon) ?? C(hexagon)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(value,
                  for: key)
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
}
