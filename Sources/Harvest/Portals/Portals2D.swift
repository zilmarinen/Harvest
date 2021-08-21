//
//  Portals2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow
import SpriteKit

public class Portals2D: FootprintGrid2D<PortalChunk2D, PortalTile2D> {
    
    public func add(portal portalType: PortalType, coordinate: Coordinate, configure: ChunkConfiguration? = nil) -> PortalChunk2D? {
        
        guard let map = map,
              map.validate(coordinate: coordinate, grid: .portals) else { return nil }
        
        return super.add(chunk: Footprint(coordinate: coordinate)) { portal in
            
            portal.portalType = portalType
            
            configure?(portal)
        }
    }
}
