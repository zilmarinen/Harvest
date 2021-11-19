//
//  SurfaceTileset.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import AppKit
import Foundation
import Meadow

public struct SurfaceTileset {
    
    public let tiles: [SurfaceTilesetTile]
    
    public init() throws {
        
        do {
        
            let tilemap = try NSDataAsset.asset(named: "surface_tilemap", in: .module)
        
            let decoder = JSONDecoder()
        
            tiles = try decoder.decode([SurfaceTilesetTile].self, from: tilemap.data)
        }
        catch {
            
            throw(error)
        }
    }
}

extension SurfaceTileset {
    
    public func tiles(with sockets: Int) -> [SurfaceTilesetTile] {
        
        return tiles.filter { $0.sockets == sockets }
    }
}
