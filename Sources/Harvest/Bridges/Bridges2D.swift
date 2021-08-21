//
//  Bridges2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class Bridges2D: Grid2D<BridgeChunk2D, BridgeTile2D> {
    
    public enum Overlay {
        
        case none
        case tileType
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
    
    public override func add(tile coordinate: Coordinate, configure: TileConfiguration? = nil) -> BridgeTile2D? {
        
        guard let map = map,
              map.validate(coordinate: coordinate, grid: .bridges) else { return nil }
        
        return super.add(tile: coordinate, configure: configure)
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
