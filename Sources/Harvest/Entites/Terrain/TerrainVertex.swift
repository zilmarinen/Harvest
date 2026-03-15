//
//  TerrainVertex.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille

public struct TerrainVertex: Codable,
                             Hashable {
    
    public let vertex: Triangle.Vertex
    
    public let biome: Biome
    public let elevation: Int
}
