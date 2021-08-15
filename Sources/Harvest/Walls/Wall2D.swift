//
//  Wall2D.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Meadow
import SpriteKit

public class Wall2D: Grid2D<WallChunk2D, WallTile2D> {
    
    public enum Overlay {
        
        case none
        case type
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
    
    public override func add(tile coordinate: Coordinate, configure: TileConfiguration? = nil) -> WallTile2D? {
        
        guard let harvest = harvest,
              harvest.validate(coordinate: coordinate, grid: .walls),
              let surfaceTile = harvest.surface.find(tile: coordinate) else { return nil }
        
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
