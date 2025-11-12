//
//  TriangularGrid.swift
//
//  Created by Zack Brown on 17/09/2025.
//

import Deltille
import RealityKit

public class TriangularGrid<R: TriangularRegion<C, T>,
                            C: TriangularChunk<T>,
                            T: Codable>: Entity {}

extension TriangularGrid {
    
    internal var isEmpty: Bool {
        
        regions.isEmpty
    }
    
    internal var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

extension TriangularGrid {
    
    internal func value(for tile: Triangle) -> T? {
        
        guard let region = region(for: tile) else { return nil }
        
        return region.value(for: tile)
    }
    
    internal func set(_ value: T?,
                      for tile: Triangle) {
        
        let region = region(for: tile) ?? R(tile.transpose(.tile,
                                                           .region))
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: tile)
        
        if let region = region as? HasSoilableComponent {
         
            region.becomeDirty()
        }
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
    
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
}
