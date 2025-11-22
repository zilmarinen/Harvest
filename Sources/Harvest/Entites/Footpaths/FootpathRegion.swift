//
//  FootpathRegion.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import Deltille
import RealityKit

internal class FootpathRegion: TriangularRegion<FootpathChunk,
                                                FootpathType> {}

extension FootpathRegion {
 
    internal var dirtyChunks: [FootpathChunk] {
        
        chunks.filter { $0.isDirty }
    }
}
