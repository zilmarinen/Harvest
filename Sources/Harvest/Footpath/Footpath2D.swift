//
//  Footpath2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow
import SpriteKit

public class Footpath2D: Grid2D<FootpathChunk2D, FootpathTile2D> {
    
    public enum Overlay {
        
        case none
        case pattern
    }
    
    public var overlay: Overlay = .none {
        
        didSet {
            
            if oldValue != overlay {
                
                for tile in tiles {
                    
                    tile.becomeDirty()
                }
            }
        }
    }
    
    lazy var tilemap: FootpathTilemap = {
        
        guard let tilemap = try? FootpathTilemap() else { fatalError("Error loading footpath tilemap") }
        
        return tilemap
    }()
    
    public override func add(tile coordinate: Coordinate, configure: TileConfiguration? = nil) -> FootpathTile2D? {
        
        guard let map = map,
              map.validate(coordinate: coordinate, grid: .footpath),
              let surfaceTile = map.surface.find(tile: coordinate) else { return nil }
        
        return super.add(tile: surfaceTile.coordinate, configure: configure)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let (even, odd) = sortedTiles
        
        for tile in even {
            
            tile.collapse()
        }
        
        for tile in odd {
            
            tile.collapse()
        }
        
        return super.clean()
    }
}
