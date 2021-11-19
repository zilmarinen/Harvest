//
//  Seams2D.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import Meadow
import SpriteKit

public class Seams2D: Grid2D<SeamChunk2D, SeamTile2D> {
    
    public func add(seam coordinate: Coordinate, configure: TileConfiguration? = nil) -> SeamTile2D? {
        
        guard validate(coordinate: coordinate) else { return nil }
        
        return super.add(tile: coordinate, configure: configure)
    }
    
    func validate(coordinate: Coordinate) -> Bool {
        
        guard let map = map,
              map.actors.find(actor: coordinate) == nil,
              map.bridges.find(tile: coordinate) == nil,
              map.buildings.find(chunk: coordinate) == nil,
              map.foliage.find(chunk: coordinate) == nil,
              map.footpath.find(tile: coordinate) == nil,
              map.portals.find(chunk: coordinate) == nil,
              map.stairs.find(chunk: coordinate) == nil,
              map.surface.find(tile: coordinate) != nil,
              map.walls.find(tile: coordinate) == nil,
              map.water.find(tile: coordinate) == nil else { return false }
        
        return true
    }
}
