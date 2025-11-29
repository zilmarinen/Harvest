//
//  DataSourceSlice.swift
//
//  Created by Zack Brown on 29/11/2025.
//

import Deltille

@MainActor
internal class DataSourceSlice<C: TriangularChunk,
                               V: Codable>: Codable,
                                            @preconcurrency Equatable,
                                            @preconcurrency Hashable  {
    
    internal let region: TriangularRegion<C>?
    internal let chunks: [HexagonalChunkDataSource<V>]
    
    internal init(region: TriangularRegion<C>?,
                  chunks: [HexagonalChunkDataSource<V>]) {
        
        self.region = region
        self.chunks = chunks
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(region?.triangle)
    }
    
    public static func == (lhs: DataSourceSlice,
                           rhs: DataSourceSlice) -> Bool {
        
        lhs.region?.triangle == rhs.region?.triangle
    }
}

extension DataSourceSlice where C == TerrainChunk,
                                V == BiomeVertex {
    
    internal convenience init(empty triangle: Triangle) {
        
        let region = TriangularRegion<TerrainChunk>(triangle)
        
        let tile = triangle.transpose(.region,
                                      .tile)
        let hexagons = Array(Set(tile.vertices.map {
            
            Hexagon($0.position(.tile),
                    .chunk)
        }))
        
        for vertex in tile.vertices {
            
            region.propagate(vertex: vertex)
        }
        
        self.init(region: region,
                  chunks: hexagons.map { .init($0) })
    }
}
