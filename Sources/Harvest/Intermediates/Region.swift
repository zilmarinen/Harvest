//
//  Region.swift
//
//  Created by Zack Brown on 13/09/2025.
//

import Deltille

public final class Region: Codable,
                           Equatable,
                           Hashable {
    
    public let coordinate: Coordinate
    public var identifier: String
    
    internal let region: TerrainRegion
    internal let biomes: [BiomeChunk]
    
    @MainActor
    public init(empty triangle: Triangle) {
        
        let tile = triangle.transpose(.region,
                                      .tile)
        let hexagons = tile.vertices.map {
            
            Hexagon($0.position(.tile),
                    .chunk)
        }
        
        self.coordinate = triangle.vertex.position
        self.identifier = triangle.id
        self.region = .init(empty: triangle)
        self.biomes = hexagons.map {
            
            let chunk = BiomeChunk($0)
            
            for vertex in tile.vertices {
                
                guard $0.contains(vertex.position(.tile),
                                  .chunk) else { continue }
                
                chunk.set(.prairie,
                          1,
                          for: vertex)
            }
            
            return chunk
        }
    }
    
    internal init(coordinate: Coordinate,
                  identifier: String,
                  region: TerrainRegion,
                  biomes: [BiomeChunk]) {
     
        self.coordinate = coordinate
        self.identifier = identifier
        self.region = region
        self.biomes = biomes
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(coordinate)
    }
}

extension Region {
    
    public static func == (lhs: Region,
                           rhs: Region) -> Bool {
        
        lhs.coordinate == rhs.coordinate
    }
}
