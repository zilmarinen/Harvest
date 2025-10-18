//
//  Biosphere.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class Biosphere: HexagonalGrid<BiomeChunk> {
    
    internal required init() {
        
        super.init()
        
        name = Entity.Identifier.biosphere.id
    }
}

extension Biosphere {
    
    internal func get(biome vertex: Triangle.Vertex) -> BiomeVertex? {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon) else { return nil }
        
        return chunk.get(value: vertex)
    }
    
    internal func set(_ biome: Biome,
                      _ height: Int,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon) ?? BiomeChunk(hexagon)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(biome,
                  height,
                  for: vertex)
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
    
    internal func slice(for chunk: Triangle) -> BiomeSlice {
        
        let sieve = chunk.sieve(for: .chunk)
        
        let vertices = sieve.vertices.reduce(into: [Triangle.Vertex : BiomeVertex]()) { result, vertex in
            
            guard let biome = get(biome: vertex) else { return }
            
            result[vertex] = biome
        }
        
        return .init(sieve: sieve,
                     vertices: vertices)
    }
}
