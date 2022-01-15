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
    
    typealias Pair = (crown: SurfaceTilesetTile, throne: SurfaceTilesetTile)
    
    func tiles(matching bitmask: Int, material: SurfaceMaterial, occupancy: OrdinalPattern<SurfaceSocket>) -> [Pair] {
        
        let matches = tiles.filter { $0.material == material && $0.bitmasks.contains(bitmask) }
        let thrones = matches.filter { $0.volume == .throne }
        let crowns = matches.filter { $0.volume == .crown }
        
        var pairs: [Pair] = []
        
        for throne in thrones {
            
            guard let bitmaskIndex = throne.bitmasks.firstIndex(of: bitmask) else { continue }
            
            let ordinal = throne.rotations[bitmaskIndex]
            
            let sockets = throne.sockets.rotated(ordinal: ordinal)
            
            guard occupancy.has(vacancy: sockets) else { continue }
            
            let crown = crowns.first { $0.variation == throne.variation }
            
            guard let crown = crown  else { continue }
            
            pairs.append((crown, throne))
        }
        
        return pairs.sorted { $0.throne.sockets.area > $1.throne.sockets.area }
    }
}
