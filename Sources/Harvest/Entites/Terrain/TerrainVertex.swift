//
//  TerrainVertex.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille
import Lattice

public struct TerrainVertex: DataStoreValue {
    
    public let vertex: Triangle.Vertex
    
    public let biome: Biome
    public let elevation: Int
}
