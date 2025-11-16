//
//  WaterRegion.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import RealityKit

internal class WaterRegion: TriangularRegion<WaterChunk,
                                             WaterTile>,
                            HasSoilableComponent {}

extension WaterRegion {
 
    internal var dirtyChunks: [WaterChunk] {
        
        chunks.filter { $0.isDirty }
    }
}
