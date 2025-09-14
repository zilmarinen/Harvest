//
//  Region.swift
//  Harvest
//
//  Created by Zack Brown on 13/09/2025.
//

import Deltille

public final class Region: Codable,
                           Equatable,
                           Hashable {
    
    public let coordinate: Coordinate
    public var identifier: String
    
    let region: TerrainRegion
    let heightMap: [HeightMapChunk]
    
    @MainActor
    public init(empty coordinate: Coordinate) {
        
        let triangle = Triangle(coordinate)
        let tile = triangle.transpose(.region,
                                      .tile)
        let hexagons = tile.vertices.map {
            
            Hexagon($0.position(.tile),
                    .chunk)
        }
        
        self.coordinate = coordinate
        self.identifier = coordinate.id
        self.region = .init(empty: triangle)
        self.heightMap = hexagons.map {
            
            let chunk = HeightMapChunk(hexagon: $0)
            
            for vertex in tile.vertices {
                
                guard $0.contains($0.position(.tile),
                                  .chunk) else { continue }
                
                chunk.set(1,
                          1,
                          for: vertex)
            }
            
            return chunk
        }
    }
    
    internal init(coordinate: Coordinate,
                  identifier: String,
                  region: TerrainRegion,
                  heightMap: [HeightMapChunk]) {
     
        self.coordinate = coordinate
        self.identifier = identifier
        self.region = region
        self.heightMap = heightMap
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
