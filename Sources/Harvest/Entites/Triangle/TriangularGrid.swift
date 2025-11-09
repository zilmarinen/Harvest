//
//  TriangularGrid.swift
//
//  Created by Zack Brown on 17/09/2025.
//

import Deltille
import RealityKit

public class TriangularGrid<R: TriangularRegion<C>,
                            C: TriangularEntity>: Entity {
    
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
