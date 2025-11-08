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
    
    internal let biomes: [BiomeChunk]
    internal let foliage: FoliageRegion?
    internal let terrain: TerrainRegion
    internal let water: WaterRegion?
    
    internal init(coordinate: Coordinate,
                  identifier: String,
                  biomes: [BiomeChunk],
                  foliage: FoliageRegion? = nil,
                  terrain: TerrainRegion,
                  water: WaterRegion? = nil) {
     
        self.coordinate = coordinate
        self.identifier = identifier
        self.biomes = biomes
        self.foliage = foliage
        self.terrain = terrain
        self.water = water
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(coordinate)
    }
    
    public static func == (lhs: Region,
                           rhs: Region) -> Bool {
        
        lhs.coordinate == rhs.coordinate
    }
}

extension Region {
    
    @MainActor
    public convenience init(empty triangle: Triangle) {
        
        let tile = triangle.transpose(.region,
                                      .tile)
        let hexagons = Array(Set(tile.vertices.map {
            
            Hexagon($0.position(.tile),
                    .chunk)
        }))
        
        let biomes = hexagons.map {
            
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
        
        self.init(coordinate: triangle.vertex.position,
                  identifier: triangle.id,
                  biomes: biomes,
                  terrain: .init(empty: triangle))
    }
}

extension Region {
    
    public func remove(tiles region: Triangle) {
        
        //TODO: remove overlapping biome / terrain
    }
}
