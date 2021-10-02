//
//  SurfaceTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation
import Meadow

public class SurfaceTilesetTile: TilesetTile {
    
    private enum CodingKeys: String, CodingKey {
        
        case overlay = "o"
    }
    
    public let overlay: SurfaceOverlay
    
    required init(pattern: Int, uvs: UVs, rawType: Int) throws {
        
        guard let overlay = SurfaceOverlay(rawValue: rawType) else { fatalError() }
        
        self.overlay = overlay
        
        try super.init(pattern: pattern, uvs: uvs, rawType: rawType)
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        overlay = try container.decode(SurfaceOverlay.self, forKey: .overlay)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(overlay, forKey: .overlay)
        
        try super.encode(to: encoder)
    }
}
