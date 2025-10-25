//
//  HexagonalGrid.swift
//
//  Created by Zack Brown on 17/09/2025.
//

import Deltille
import RealityKit

internal class HexagonalGrid<R: HexagonalRegion<C>,
                             C: HexagonalEntity>: Entity {
    
    internal var isEmpty: Bool {
        
        regions.isEmpty
    }
    
    internal var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

extension HexagonalGrid {
    
    internal func region(for hexagon: Hexagon) -> R? {
        
        regions.first {
            
            $0.hexagon == hexagon
        }
    }
    
    internal func chunks(intersecting triangle: Triangle) -> [C] {
        
        regions.flatMap {
         
            $0.chunks(intersecting: triangle)
        }
    }
}
