//
//  Stairs2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class Stairs2D: FootprintGrid2D<StairChunk2D, StairTile2D> {
    
    public func add(stairs bounds: GridBounds, configure: ChunkConfiguration? = nil) -> StairChunk2D? {
        
        guard let harvest = harvest else { return nil }
        
        let footprint = Footprint(bounds: bounds)
        
        guard harvest.validate(footprint: footprint, grid: .bridges) else { return nil }
        
        return super.add(chunk: footprint) { stairs in
            
            stairs._footprint = footprint
            
            configure?(stairs)
        }
    }
}
