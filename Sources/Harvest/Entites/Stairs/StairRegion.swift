//
//  StairRegion.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import Newel
import RealityKit

internal class StairRegion: TriangularRegion<StairChunk,
                                             Stoop> {}

extension StairRegion {
 
    internal var dirtyChunks: [StairChunk] {
        
        chunks.filter { $0.isDirty }
    }
}
