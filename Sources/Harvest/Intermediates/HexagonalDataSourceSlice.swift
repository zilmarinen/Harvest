//
//  HexagonalDataSourceSlice.swift
//
//  Created by Zack Brown on 29/11/2025.
//

import Deltille

@MainActor
public class HexagonalDataSourceSlice<C: TriangularChunk,
                                      V: Codable>: Codable,
                                                   @preconcurrency Equatable,
                                                   @preconcurrency Hashable  {
    
    public let dataSource: [HexagonalChunkDataSource<V>]
    public let grid: TriangularRegion<C>?
    
    internal init(dataSource: [HexagonalChunkDataSource<V>],
                  grid: TriangularRegion<C>?) {
        
        self.dataSource = dataSource
        self.grid = grid
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(grid?.triangle)
    }
    
    public static func == (lhs: HexagonalDataSourceSlice,
                           rhs: HexagonalDataSourceSlice) -> Bool {
        
        lhs.grid?.triangle == rhs.grid?.triangle
    }
}

extension HexagonalDataSourceSlice {
    
    internal var isEmpty: Bool {
        
        dataSource.isEmpty || grid == nil
    }
}

extension HexagonalDataSourceSlice {
 
    internal func remove(values keys: [HexagonalChunkDataSource<V>.K]) {
        
        dataSource.forEach {
            
            $0.remove(values: keys)
        }
        
        grid?.chunks.forEach {
            
            $0.becomeDirty()
        }
        
        grid?.becomeDirty()
    }
}

// MARK: Terrain

extension HexagonalDataSourceSlice where C == TerrainChunk,
                                         V == TerrainVertex {
    
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
            
            for chunk in chunks  {
                
                chunk.set(.init(vertex: vertex,
                                biome: .boreal,
                                elevation: 1),
                          for: vertex)
            }
        }
        
        region.propagate(triangle: tile)
        
        self.init(dataSource: chunks,
                  grid: region)
    }
}
