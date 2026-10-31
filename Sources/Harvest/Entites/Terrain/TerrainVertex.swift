//
//  TerrainVertex.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import Lattice

public struct TerrainVertex: DataStoreValue {
    
    public typealias T = Hexagon
    
    public let vertex: Triangle.Vertex
    
    public let footprint: Set<Triangle.Vertex>
    
    public let biome: Biome
}
