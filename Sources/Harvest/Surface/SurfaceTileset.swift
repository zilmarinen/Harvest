//
//  SurfaceTileset.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import Euclid
import Foundation
import Meadow

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

public class SurfaceTileset {
    
    private let tiles: [SurfaceTilesetTile]
    private var meshes: [String : Mesh] = [:]
    
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
    
    func mesh(for tile: SurfaceTilesetTile) -> Mesh? {
        
        if let mesh = meshes[tile.identifier] {
            
            return mesh
        }
        
        guard let mesh = tile.mesh else { return nil }
        
        meshes[tile.identifier] = mesh
        
        return mesh
    }
}

extension SurfaceTileset {
    
    public func tiles(matching pattern: OrdinalPattern<SurfaceMaterial>) -> [SurfaceTilesetTile] {
        
        return tiles.filter { $0.sockets.lower.isEqual(to: pattern) }
    }
    
    public func tiles(matching bitmask: Int, style: SurfaceStyle?) -> [SurfaceTilesetTile] {
        
        return tiles.filter { tile in
            
            let equal = tile.bitmask == bitmask
            
            guard let style = style else { return equal }

            return equal && tile.style == style
        }
    }
}
