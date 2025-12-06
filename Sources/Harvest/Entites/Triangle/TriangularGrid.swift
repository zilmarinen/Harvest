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
        
        guard let existing = self.region(for: region.triangle,
                                         .region) else {
            
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
    
    internal func region(for triangle: Triangle,
                         _ scale: Triangle.Scale = .tile) -> R? {
        
        let match = triangle.transpose(scale,
                                       .region)
        
        return regions.first {
            
            $0.triangle == match
        }
    }
    
    internal func chunk(for triangle: Triangle,
                        _ scale: Triangle.Scale = .tile) -> C? {
        
        guard let region = region(for: triangle,
                                  scale) else { return nil }
        
        return region.chunk(for: triangle,
                            scale)
    }
    
    internal func chunks(intersecting triangle: Triangle,
                         _ scale: Triangle.Scale = .region) -> [C] {
        
        let match = triangle.transpose(scale,
                                       .region)
        
        return regions.flatMap {
         
            $0.chunks(intersecting: match)
        }
    }
    
    internal func propagate(triangle: Triangle,
                            _ scale: Triangle.Scale = .tile) {
        
        let region = region(for: triangle) ?? .init(triangle.transpose(scale,
                                                                       .region))
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.propagate(triangle: triangle)
    }
    
    internal func propagate(vertex: Triangle.Vertex) {
        
        for triangle in vertex.tiles {
            
            propagate(triangle: triangle)
        }
    }
}
