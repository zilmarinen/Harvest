//
//  HexagonalRegionDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class HexagonalRegionDataSource<C: HexagonalChunkDataSource<V>,
                                       V: Codable>: HexagonalRegion<C> {
    
    internal func merge(_ chunk: C) {
        
        guard let existing = self.chunk(for: chunk.hexagon) else {
        
            addChild(chunk)
            
            return
        }
        
        existing.merge(chunk.dataSource)
    }
}

extension HexagonalRegionDataSource {
    
    internal func value(for vertex: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon) else { return nil }
        
        return chunk.value(for: vertex)
    }
    
    internal func set(_ value: V?,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon) ?? C(hexagon)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(value,
                  for: vertex)
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
}
