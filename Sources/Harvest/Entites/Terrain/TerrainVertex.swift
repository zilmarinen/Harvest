//
//  TerrainVertex.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import Lattice

internal struct TerrainVertex: DataStoreValue {
    
    internal typealias T = Hexagon
    
    internal let vertex: Triangle.Vertex
    
    internal let footprint: Set<Triangle.Vertex>
    
    internal let biome: Biome
}
