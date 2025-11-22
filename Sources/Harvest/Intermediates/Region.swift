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
    
    internal let biomes: [HexagonalChunkDataSource<BiomeVertex>]
    internal let foliage: FoliageRegion?
    internal let terrain: TerrainRegion
    internal let water: WaterRegion?
    
    public var identifier: String {
        
        get { terrain.name }
        set { terrain.name = newValue }
    }
    
    internal init(coordinate: Coordinate,
                  biomes: [HexagonalChunkDataSource<BiomeVertex>],
                  foliage: FoliageRegion? = nil,
                  terrain: TerrainRegion,
                  water: WaterRegion? = nil) {
     
        self.coordinate = coordinate
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
        
        //TODO: Tidy up empty region generation
        let tile = triangle.transpose(.region,
                                      .tile)
        let hexagons = Array(Set(tile.vertices.map {
            
            Hexagon($0.position(.tile),
                    .chunk)
        }))
        
        let biomes = hexagons.map {
            
            let chunk = HexagonalChunkDataSource<BiomeVertex>($0)
            
            for vertex in tile.vertices {
                
                guard $0.contains(vertex.position(.tile),
                                  .chunk) else { continue }
                
                chunk.set(.init(vertex: vertex,
                                biome: .prairie,
                                elevation: 1),
                          for: vertex)
            }
            
            return chunk
        }
        
        self.init(coordinate: triangle.vertex.position,
                  biomes: biomes,
                  terrain: .init(empty: triangle))
    }
}

extension Region {
    
    public func remove(tiles region: Triangle) {
        
        //TODO: remove overlapping biome / terrain
    }
}
