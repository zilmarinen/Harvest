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
        case material
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
    
    public override func add(tile coordinate: Coordinate, configure: TileConfiguration? = nil) -> FootpathTile2D? {
        
        guard validate(coordinate: coordinate) else { return nil }
        
        return super.add(tile: coordinate, configure: configure)
    }
    
    func validate(coordinate: Coordinate) -> Bool {
        
        guard let map = map,
              map.bridges.find(tile: coordinate) == nil,
              map.buildings.find(chunk: coordinate) == nil,
              map.foliage.find(chunk: coordinate) == nil,
              map.stairs.find(chunk: coordinate) == nil,
              map.surface.find(tile: coordinate) != nil,
              map.walls.find(tile: coordinate) == nil,
              map.water.find(chunk: coordinate) == nil else { return false }
        
        return true
    }
}
