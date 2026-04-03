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
        
        let vertices = Set(tile.perimeter.flatMap {
            
            $0.vertices
        })
        
        for vertex in vertices {
            
            let value = TerrainVertex(vertex: vertex,
                                      biome: .chaparral,
                                      elevation: 1)
            
            lattice.set(value,
                        for: vertex)
        }
        
        guard let slice = lattice.slice(region: triangle) else { return nil }
        
        self.init(dataStore: slice.dataStore,
                  region: slice.region)
    }
}

