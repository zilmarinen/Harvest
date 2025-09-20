//
//  HeightMap.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import Foundation
import RealityKit

internal class HeightMap: HexagonalGrid<HeightMapChunk> {}

extension HeightMap {
    
    internal func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon) else { return nil }
        
        return chunk.get(value: vertex)
    }
    
    internal func set(_ height: Int,
                      _ material: Int,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon) ?? HeightMapChunk(hexagon)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(height,
                  material,
                  for: vertex)
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
    
    internal func slice(for chunk: Triangle) -> HeightMapSlice {
        
        let sieve = chunk.sieve(for: .chunk)
        
        let vertices = sieve.vertices.reduce(into: [Triangle.Vertex : HeightMapVertex]()) { result, vertex in
            
            guard let value = get(value: vertex) else { return }
            
            result[vertex] = value
        }
        
        return .init(sieve: sieve,
                     vertices: vertices)
    }
}
