//
//  BiomeSlice.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille

internal struct BiomeSlice {
    
    internal let sieve: Triangle.Sieve
    
    internal let vertices: [Triangle.Vertex : BiomeVertex]
}

extension BiomeSlice {
    
    internal var tiles: [Triangle.Vertex : BiomeTile] {
        
        sieve.tiles.reduce(into: [Triangle.Vertex : BiomeTile]()) { result, tile in

            let vertices = tile.vertices.compactMap {

                self.vertices[$0]
            }

            guard !vertices.isEmpty else { return }

            result[tile.vertex] = .init(triangle: tile,
                                        vertices: vertices)
        }
    }
}
