//
//  TriangularGrid.swift
//
//  Created by Zack Brown on 17/09/2025.
//

import Deltille
import RealityKit

public class TriangularGrid<R: TriangularRegion<C>,
                            C: TriangularEntity>: Entity {
    
    internal func merge(_ region: R) {
        
        let match = region.triangle.transpose(.region,
                                              .tile)
        
        guard let existing = self.region(for: match) else {
            
            return addChild(region)
        }
        
        for chunk in region.chunks {
            
            guard existing.chunk(for: chunk.triangle) == nil else { continue }
            
            existing.addChild(chunk)
        }
    }
}

extension TriangularGrid {
    
    internal var isEmpty: Bool {
        
        regions.isEmpty
    }
    
    internal var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
    
    internal var dirtyRegions: [R] {
        
        regions.filter {
            
            $0.isDirty
        }
    }
}

extension TriangularGrid {
    
    internal func region(for tile: Triangle) -> R? {
        
        let region = tile.transpose(.tile,
                                    .region)
        
        return regions.first {
            
            $0.triangle == region
        }
    }
    
    internal func chunk(for tile: Triangle) -> C? {
        
        guard let region = region(for: tile) else { return nil }
        
        return region.chunk(for: tile)
    }
    
    internal func chunks(intersecting region: Triangle) -> [C] {
        
        regions.flatMap {
         
            $0.chunks(intersecting: region)
        }
    }
    
    internal func propagate(triangle tile: Triangle) {
        
        let region = region(for: tile) ?? .init(tile.transpose(.tile,
                                                               .region))
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.propagate(triangle: tile)
    }
    
    internal func propagate(vertex: Triangle.Vertex) {
        
        for triangle in vertex.tiles {
            
            propagate(triangle: triangle)
        }
    }
}
