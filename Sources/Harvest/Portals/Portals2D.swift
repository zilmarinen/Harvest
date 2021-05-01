//
//  Portals2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow
import SpriteKit

public class Portals2D: FootprintGrid2D<PortalChunk2D> {
    
    public override func add(chunk footprint: Footprint, configure: ChunkConfiguration? = nil) -> PortalChunk2D? {
        
        guard let harvest = harvest else { return nil }
        
        for coordinate in footprint.nodes {
            
            if !harvest.validate(coordinate: coordinate, grid: .portals) {
                
                return nil
            }
        }
        
        return super.add(chunk: footprint, configure: configure)
    }
}
