//
//  Seams2D.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import Meadow
import SpriteKit

public class Seams2D: Grid2D<SeamChunk2D, SeamTile2D> {
    
    public func add(seam coordinate: Coordinate, configure: TileConfiguration? = nil) -> SeamTile2D? {
        
        guard let map = map,
              map.validate(coordinate: coordinate, grid: .seams) else { return nil }
        
        return super.add(tile: coordinate, configure: configure)
    }
}
