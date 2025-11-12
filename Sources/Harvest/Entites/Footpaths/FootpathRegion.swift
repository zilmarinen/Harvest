//
//  FootpathRegion.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import Deltille
import Foundation
import RealityKit

internal class FootpathRegion: HexagonalRegion<FootpathChunk,
                                               FootpathType>,
                               HasSoilableComponent {}

extension FootpathRegion {
 
    internal var dirtyChunks: [FootpathChunk] {
        
        chunks.filter { $0.isDirty }
    }
}
