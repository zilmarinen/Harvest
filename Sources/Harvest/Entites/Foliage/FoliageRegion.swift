//
//  FoliageRegion.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import RealityKit

internal class FoliageRegion: TriangularRegion<FoliageChunk,
                                               Triangle> {}

extension FoliageRegion {
 
    internal var dirtyChunks: [FoliageChunk] {
        
        chunks.filter { $0.isDirty }
    }
}
