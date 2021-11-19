//
//  Stairs2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class Stairs2D: PropGrid2D<StairChunk2D, StairTile2D> {

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
