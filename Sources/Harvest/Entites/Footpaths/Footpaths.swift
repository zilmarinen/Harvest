//
//  Footpaths.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import Deltille
import Foundation
import RealityKit

internal class Footpaths: HexagonalGrid<FootpathRegion,
                                        FootpathChunk,
                                        FootpathType> {
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.footpaths.id
    }
}

extension Footpaths {
 
    internal var dirtyRegions: [FootpathRegion] {
        
        regions.filter { $0.isDirty }
    }
}
