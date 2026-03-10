//
//  HexagonalLatticeSlice.swift
//  Harvest
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille
import Lattice

// MARK: Terrain

extension HexagonalLatticeSlice where C == TerrainChunk,
                                      V == TerrainVertex {
    
    internal init?(empty triangle: Triangle) {
        
        let lattice = HexagonalLattice<C, V>()
        
        let tile = triangle.transpose(.region,
                                      .tile)
        
        for vertex in tile.vertices {
            
            let value = TerrainVertex(vertex: vertex,
                                      biome: .rainforest,
                                      elevation: 1)
            
            lattice.set(value,
                        for: vertex)
        }
        
        guard let slice = lattice.slice(region: triangle) else { return nil }
        
        self.init(dataSource: slice.dataSource,
                  region: slice.region)
    }
}

