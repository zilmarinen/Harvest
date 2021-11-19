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
        
        guard validate(coordinate: coordinate) else { return nil }
        
        return super.add(tile: coordinate, configure: configure)
    }
    
    func validate(coordinate: Coordinate) -> Bool {
        
        guard let map = map,
              let surfaceTile = map.surface.find(tile: coordinate),
              map.actors.find(actor: coordinate) == nil,
              map.buildings.find(chunk: coordinate) == nil,
              map.foliage.find(chunk: coordinate) == nil,
              map.footpath.find(tile: coordinate) == nil,
              map.portals.find(chunk: coordinate) == nil,
              map.stairs.find(chunk: coordinate) == nil,
              map.walls.find(tile: coordinate) == nil,
              coordinate.y > surfaceTile.coordinate.y else { return false }
        
        return true
    }
}
