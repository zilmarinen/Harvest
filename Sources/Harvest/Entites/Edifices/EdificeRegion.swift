//
//  EdificeRegion.swift
//
//  Created by Zack Brown on 10/11/2025.
//

import Deltille
import RealityKit

internal class EdificeRegion: TriangularRegion<EdificeChunk,
                                               Triangle.Septomino>,
                              HasSoilableComponent {}

extension EdificeRegion {
 
    internal var dirtyChunks: [EdificeChunk] {
        
        chunks.filter { $0.isDirty }
    }
}
