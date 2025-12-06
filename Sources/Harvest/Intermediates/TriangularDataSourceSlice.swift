//
//  TriangularDataSourceSlice.swift
//
//  Created by Zack Brown on 02/12/2025.
//

import Deltille

@MainActor
internal class TriangularDataSourceSlice<C: TriangularChunk,
                                         V: Codable>: Codable,
                                                      @preconcurrency Equatable,
                                                      @preconcurrency Hashable {
    
    internal let dataSource: [TriangularChunkDataSource<V>]
    internal let grid: TriangularRegion<C>?
    
    internal init(dataSource: [TriangularChunkDataSource<V>],
                  grid: TriangularRegion<C>?) {
        
        self.dataSource = dataSource
        self.grid = grid
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(grid?.triangle)
    }
    
    public static func == (lhs: TriangularDataSourceSlice,
                           rhs: TriangularDataSourceSlice) -> Bool {
        
        lhs.grid?.triangle == rhs.grid?.triangle
    }
}

extension TriangularDataSourceSlice {
    
    internal var isEmpty: Bool {
        
        dataSource.isEmpty || grid == nil
    }
}
