//
//  Region.swift
//
//  Created by Zack Brown on 13/09/2025.
//

import Deltille

@MainActor
public struct Region: Codable,
                      @preconcurrency Equatable,
                      @preconcurrency Hashable {

    public let triangle: Triangle
    public var identifier: String = ""
    
    internal let buildings: TriangularDataSourceSlice<BuildingChunk, BuildingFootprint>?
    internal let foliage: TriangularDataSourceSlice<FoliageChunk, Triangle>?
    internal let footpaths: HexagonalDataSourceSlice<FootpathChunk, FootpathType>?
    internal let portals: TriangularDataSourceSlice<PortalChunk, PortalTile>?
    internal let staircases: TriangularDataSourceSlice<StaircaseChunk, StaircaseFootprint>?
    internal let terrain: HexagonalDataSourceSlice<TerrainChunk, TerrainVertex>?
    internal let water: TriangularDataSourceSlice<WaterChunk, WaterTile>?
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(triangle)
    }
    
    public static func == (lhs: Region,
                           rhs: Region) -> Bool {
        
        lhs.triangle == rhs.triangle
    }
}

extension Region {
    
    public var isEmpty: Bool {
        
        terrain?.isEmpty ?? true
    }
}

extension Region {
    
    public func remove(tiles region: Triangle) {
        
        let sieve = region.sieve(for: .region)
        
        buildings?.remove(values: sieve.tiles)
        foliage?.remove(values: sieve.tiles)
        footpaths?.remove(values: sieve.vertices)
        portals?.remove(values: sieve.tiles)
        staircases?.remove(values: sieve.tiles)
        terrain?.remove(values: sieve.vertices)
        water?.remove(values: sieve.tiles)
    }
}

extension Region {
    
    public init(empty triangle: Triangle) {
        
        self.init(triangle: triangle,
                  buildings: nil,
                  foliage: nil,
                  footpaths: nil,
                  portals: nil,
                  staircases: nil,
                  terrain: .init(empty: triangle),
                  water: nil)
        
        self.identifier = triangle.id
    }
}
