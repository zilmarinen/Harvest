//
//  FootpathTilesetTile.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Foundation
import Meadow

public class FootpathTilesetTile: TilesetTile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "tt"
    }
    
    public let tileType: FootpathTileType
    
    required init(pattern: Int, uvs: UVs, rawType: Int) throws {
        
        guard let tileType = FootpathTileType(rawValue: rawType) else { fatalError() }
        
        self.tileType = tileType
        
        try super.init(pattern: pattern, uvs: uvs, rawType: rawType)
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(FootpathTileType.self, forKey: .tileType)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        
        try super.encode(to: encoder)
    }
}
