//
//  SurfaceTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Euclid
import Foundation
import Meadow

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

public class SurfaceTilesetTile: Codable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case bitmask = "b"
        case identifier = "id"
        case sockets = "so"
        case style = "st"
    }
    
    public let bitmask: Int
    public let identifier: String
    public let sockets: SurfaceSockets
    public let style: SurfaceStyle
    
    public init(identifier: String, sockets: SurfaceSockets, style: SurfaceStyle) {
        
        self.bitmask = sockets.bitmask
        self.identifier = identifier
        self.sockets = sockets
        self.style = style
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        bitmask = try container.decode(Int.self, forKey: .bitmask)
        identifier = try container.decode(String.self, forKey: .identifier)
        sockets = try container.decode(SurfaceSockets.self, forKey: .sockets)
        style = try container.decode(SurfaceStyle.self, forKey: .style)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bitmask, forKey: .bitmask)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(sockets, forKey: .sockets)
        try container.encode(style, forKey: .style)
    }
}

extension SurfaceTilesetTile {
    
    public static func == (lhs: SurfaceTilesetTile, rhs: SurfaceTilesetTile) -> Bool {
        
        return lhs.bitmask == rhs.bitmask && lhs.identifier == rhs.identifier && lhs.sockets == rhs.sockets && lhs.style == rhs.style
    }
}

extension SurfaceTilesetTile {
    
    var mesh: Mesh? {
        
        do {
            
            let asset = try NSDataAsset.asset(named: identifier, in: .module)
            
            return try JSONDecoder().decode(SurfaceTilesetMesh.self, from: asset.data).mesh
        }
        catch {
            
            return nil
        }
    }
}
