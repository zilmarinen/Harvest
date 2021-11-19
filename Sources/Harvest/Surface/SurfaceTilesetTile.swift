//
//  SurfaceTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation
import Meadow

public class SurfaceTilesetTile: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case sockets = "s"
    }
    
    public let sockets: Int
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sockets = try container.decode(Int.self, forKey: .sockets)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sockets, forKey: .sockets)
    }
}
