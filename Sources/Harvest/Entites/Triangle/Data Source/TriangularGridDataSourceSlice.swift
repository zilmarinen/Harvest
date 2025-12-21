//
//  TriangularGridDataSourceSlice.swift
//
//  Created by Zack Brown on 20/12/2025.
//

import Deltille

internal struct TriangularGridDataSourceSlice<V: Codable>: GridDataSourceSlice {
    
    typealias Tiles = [Triangle.Vertex : V]
    
    private let data: Tiles
    
    internal init(tiles: Tiles) {
        
        self.data = tiles
    }
}

extension TriangularGridDataSourceSlice {
    
    internal var isEmpty: Bool {
        
        data.isEmpty
    }
    
    internal var tiles: [V] {
        
        Array(data.values)
    }
}

extension TriangularGridDataSourceSlice {
 
    internal func tile(for tile: Triangle) -> V? {
        
        data[tile.vertex]
    }
}
