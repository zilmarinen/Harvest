//
//  Water.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class Water: TriangularGrid<WaterRegion,
                                     WaterChunk> {
    
    internal required init() {
        
        super.init()
        
        name = Entity.Identifier.water.id
    }
}

extension Water {
 
    internal var dirtyRegions: [WaterRegion] {
        
        regions.filter { $0.isDirty }
    }
}

extension Water {
    
    internal func get(tile triangle: Triangle) -> WaterTile? {
        
        let parent = triangle.transpose(.tile,
                                        .region)
        
        guard let region = region(for: parent) else { return nil }
        
        return region.get(tile: triangle)
    }
    
    internal func set(_ waterType: WaterType,
                      _ elevation: Int,
                      for triangle: Triangle) {
        
        let parent = triangle.transpose(.tile,
                                        .region)
        
        let region = region(for: parent) ?? .init(parent)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(waterType,
                   elevation,
                   for: triangle)
    }
}
