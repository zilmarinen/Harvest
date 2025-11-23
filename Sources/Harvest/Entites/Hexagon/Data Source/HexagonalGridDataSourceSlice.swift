//
//  HexagonalGridDataSourceSlice.swift
//
//  Created by Zack Brown on 23/11/2025.
//

import Deltille

internal struct HexagonalGridDataSourceSlice<V: Codable> {
    
    internal let sieve: Triangle.Sieve
    
    internal let vertices: [Triangle.Vertex : V]
    
    internal let tiles: [Triangle.Vertex : HexagonalGridDataSourceTile<V>]
    
    internal init(sieve: Triangle.Sieve,
                  vertices: [Triangle.Vertex : V]) {
        
        self.sieve = sieve
        self.vertices = vertices
        
        self.tiles = sieve.tiles.reduce(into: [Triangle.Vertex : HexagonalGridDataSourceTile<V>]()) { result, tile in
                    
            let vertices = tile.vertices.compactMap {

                vertices[$0]
            }

            guard !vertices.isEmpty else { return }

            result[tile.vertex] = .init(triangle: tile,
                                        vertices: vertices)
        }
    }
}

