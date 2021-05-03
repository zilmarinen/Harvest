//
//  Bridges2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class Bridges2D: FootprintGrid2D<BridgeChunk2D, BridgeTile2D> {
    
    public override func add(chunk footprint: Footprint, configure: ChunkConfiguration? = nil) -> BridgeChunk2D? {
        
        guard let harvest = harvest else { return nil }
        
        for coordinate in footprint.nodes {
            
            if !harvest.validate(coordinate: coordinate, grid: .bridges) {
                
                return nil
            }
        }
        
        return super.add(chunk: footprint, configure: configure)
    }
}
