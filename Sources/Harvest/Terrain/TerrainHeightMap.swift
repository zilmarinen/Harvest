//
//  TerrainHeightMap.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Bivouac

public final class TerrainHeightMap {
    
    public struct Vertex {
        
        public let coordinate: Coordinate
        public let elevation: Int
        public let terrainType: TerrainType
    }
    
    private var vertices: [Vertex] = []
    
    func vertex(at coordinate: Coordinate) -> Vertex? { vertices.first { $0.coordinate == coordinate } }
}
