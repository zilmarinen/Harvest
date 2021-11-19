//
//  FootpathTileset.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import AppKit
import Foundation
import Meadow

public struct FootpathTileset {

    public let tiles: [FootpathTilesetTile]
    
    public init() throws {

        do {
        
            let tilemap = try NSDataAsset.asset(named: "footpath_tilemap", in: .module)
            
            let decoder = JSONDecoder()
            
            tiles = try decoder.decode([FootpathTilesetTile].self, from: tilemap.data)
        }
        catch {
            
            throw(error)
        }
    }
}

extension FootpathTileset {
    
    public func tiles(with material: FootpathMaterial) -> [FootpathTilesetTile] {
        
        return tiles.filter { $0.material == material }
    }
}
