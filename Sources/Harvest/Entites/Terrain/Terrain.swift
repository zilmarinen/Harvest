//
//  Terrain.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import Lattice

internal class Terrain: VertexLattice<TerrainChunk, TerrainVertex> {
    
    override func clean(_ chunk: TerrainChunk,
                        _ sieve: Triangle.Sieve,
                        _ wedge: DataStoreWedge<Triangle.Vertex, TerrainVertex>) -> Bool {
        
        false
    }
}
