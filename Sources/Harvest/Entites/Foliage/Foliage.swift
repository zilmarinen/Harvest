//
//  Foliage.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class Foliage: TriangularGrid<FoliageRegion,
                                       FoliageChunk> {
    
    internal required init() {
        
        super.init()
        
        name = Entity.Identifier.foliage.id
        
        components[FoliageAssetCacheComponent.self] = .init()
    }
}

extension Foliage {
 
    internal var dirtyRegions: [FoliageRegion] {
        
        regions.filter { $0.isDirty }
    }
}

extension Foliage {
    
    internal func set(foliage triangle: Triangle) {
        
        let parent = triangle.transpose(.tile,
                                        .region)
        
        let region = region(for: parent) ?? .init(parent)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(foliage: triangle)
    }
}
