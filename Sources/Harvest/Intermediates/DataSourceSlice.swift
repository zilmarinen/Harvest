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

extension DataSourceSlice {
    
    internal var isEmpty: Bool {
        
        region == nil || chunks.isEmpty
    }
}

// MARK: Terrain

extension DataSourceSlice where C == TerrainChunk,
                                V == BiomeVertex {
    
    internal convenience init(empty triangle: Triangle) {
        
        let region = TriangularRegion<C>(triangle)
        
        let tile = triangle.transpose(.region,
                                      .tile)
        
        let hexagons = Array(Set(tile.vertices.map {
            
            Hexagon($0.position(.tile),
                    .chunk)
        }))
        
        let chunks = hexagons.map { HexagonalChunkDataSource<V>($0) }
        
        for vertex in tile.vertices {
            
            region.propagate(vertex: vertex)
            
            for chunk in chunks  {
                
                chunk.set(.init(vertex: vertex,
                                biome: .boreal,
                                elevation: 1),
                          for: vertex)
            }
        }
        
        self.init(region: region,
                  chunks: chunks)
    }
}
