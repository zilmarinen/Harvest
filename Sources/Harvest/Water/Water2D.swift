//
//  Water2D.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Meadow
import SpriteKit

public class Water2D: Grid2D<WaterChunk2D, WaterTile2D> {
    
    public enum Overlay {
        
        case none
        case elevation
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
    
    public override func add(tile coordinate: Coordinate, configure: Grid2D<WaterChunk2D, WaterTile2D>.TileConfiguration? = nil) -> WaterTile2D? {
        
        guard let map = ancestor as? Map2D,
              map.validate(coordinate: coordinate, grid: .water) else { return nil }
        
        return super.add(tile: coordinate, configure: configure)
    }
}
