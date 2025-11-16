//
//  Biosphere.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille
import RealityKit

internal class Biosphere: HexagonalGrid<BiomeRegion,
                                        BiomeChunk,
                                        BiomeVertex> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.biosphere.id
    }
}

extension Biosphere {
    
    internal func slice(for chunk: Triangle) -> BiomeSlice {
        
        let sieve = chunk.sieve(for: .chunk)
        
        let vertices = sieve.vertices.reduce(into: [Triangle.Vertex : BiomeVertex]()) { result, vertex in
            
            guard let biome = value(for: vertex) else { return }
            
            result[vertex] = biome
        }
        
        return .init(sieve: sieve,
                     vertices: vertices)
    }
    
    internal func tile(for triangle: Triangle) -> BiomeTile {
        
        let vertices = triangle.vertices.compactMap {
            
            value(for: $0)
        }
        
        return .init(triangle: triangle,
                     vertices: vertices)
    }
}
