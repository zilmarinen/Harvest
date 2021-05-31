//
//  Bridges2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class Bridges2D: FootprintGrid2D<BridgeChunk2D, BridgeTile2D> {
    
    public func add(bridge bounds: GridBounds, configure: ChunkConfiguration? = nil) -> BridgeChunk2D? {
        
        guard bounds.size.x != bounds.size.z,
              let harvest = harvest else { return nil }
        
        let footprint = Footprint(bounds: bounds)
        
        guard harvest.validate(footprint: footprint, grid: .bridges) else { return nil }
        
        return super.add(chunk: footprint) { bridge in
            
            bridge._footprint = footprint
            
            configure?(bridge)
        }
    }
}
