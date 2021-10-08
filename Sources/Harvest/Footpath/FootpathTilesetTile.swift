//
//  FootpathTilesetTile.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Foundation
import Meadow

public class FootpathTilesetTile: TilesetTile {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public let material: FootpathMaterial
    
    required init(pattern: Int, uvs: UVs, rawType: Int) throws {
        
        guard let material = FootpathMaterial(rawValue: rawType) else { fatalError() }
        
        self.material = material
        
        try super.init(pattern: pattern, uvs: uvs, rawType: rawType)
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(FootpathMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(material, forKey: .material)
        
        try super.encode(to: encoder)
    }
}
