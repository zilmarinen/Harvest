//
//  FootpathTilesetTile.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Foundation
import Meadow

public class FootpathTilesetTile: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public let material: FootpathMaterial
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(FootpathMaterial.self, forKey: .material)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(material, forKey: .material)
    }
}
