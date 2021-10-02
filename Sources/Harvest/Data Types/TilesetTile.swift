//
//  TilesetTile.swift
//
//  Created by Zack Brown on 24/03/2021.
//

import Foundation
import Meadow

public class TilesetTile: Codable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case pattern = "p"
        case uvs = "uv"
    }
    
    public let pattern: Int
    public let uvs: UVs
    
    public required init(pattern: Int, uvs: UVs, rawType: Int) throws {
        
        self.pattern = pattern
        self.uvs = uvs
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pattern = try container.decode(Int.self, forKey: .pattern)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pattern, forKey: .pattern)
        try container.encode(uvs, forKey: .uvs)
    }
}

extension TilesetTile {
    
    public static func == (lhs: TilesetTile, rhs: TilesetTile) -> Bool {
        
        return lhs.pattern == rhs.pattern && lhs.uvs == rhs.uvs
    }
}
