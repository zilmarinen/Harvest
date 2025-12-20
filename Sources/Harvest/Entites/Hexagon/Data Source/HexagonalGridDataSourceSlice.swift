//
//  HexagonalGridDataSourceSlice.swift
//
//  Created by Zack Brown on 23/11/2025.
//

import Deltille

internal struct HexagonalGridDataSourceSlice<V: Codable> {
    
    typealias Tiles = [Triangle : HexagonalGridDataSourceTile<V>]
    typealias Vertices = [Triangle.Vertex : V]
    
    private let data: Tiles
    
    internal init(sieve: Triangle.Sieve,
                  vertices: Vertices) {
        
        self.data = sieve.tiles.reduce(into: Tiles()) { result, tile in
            
            let vertices = tile.vertices.reduce(into: Vertices()) { result, vertex in
                
                guard let value = vertices[vertex] else { return }
             
                result[vertex] = value
            }

            guard !vertices.isEmpty else { return }

            result[tile] = .init(triangle: tile,
                                 vertices: vertices)
        }
    }
}

extension HexagonalGridDataSourceSlice {
    
    internal var isEmpty: Bool {
        
        data.isEmpty
    }
    
    internal var tiles: [HexagonalGridDataSourceTile<V>] {
        
        Array(data.values)
    }
}

extension HexagonalGridDataSourceSlice {
 
    internal func tile(for tile: Triangle) -> HexagonalGridDataSourceTile<V>? {
        
        data[tile]
    }
}
