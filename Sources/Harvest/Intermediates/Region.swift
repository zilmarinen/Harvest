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
    
    internal let terrain: DataSourceSlice<TerrainChunk, BiomeVertex>?
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(triangle)
    }
    
    public static func == (lhs: Region,
                           rhs: Region) -> Bool {
        
        lhs.triangle == rhs.triangle
    }
}

extension Region {
    
    public init(empty triangle: Triangle) {
        
        self.init(triangle: triangle,
                  terrain: .init(empty: triangle))
    }
}
