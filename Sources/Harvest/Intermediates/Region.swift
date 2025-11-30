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
    
    internal let edifices: EdificeRegion?
    internal let foliage: FoliageRegion?
    internal let footpaths: DataSourceSlice<FootpathChunk, FootpathType>?
    internal let stairs: StairRegion?
    internal let terrain: DataSourceSlice<TerrainChunk, BiomeVertex>?
    internal let water: WaterRegion?
    
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
    
    public init(empty triangle: Triangle) {
        
        self.init(triangle: triangle,
                  edifices: nil,
                  foliage: nil,
                  footpaths: nil,
                  stairs: nil,
                  terrain: .init(empty: triangle),
                  water: nil)
        
        self.identifier = triangle.id
    }
}
