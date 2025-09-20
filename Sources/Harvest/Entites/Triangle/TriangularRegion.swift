//
//  TriangularRegion.swift
//  Harvest
//
//  Created by Zack Brown on 17/09/2025.
//

import Deltille
import RealityKit

public class TriangularRegion<C: TriangularEntity>: TriangularEntity {
    
    internal var isEmpty: Bool {
        
        chunks.isEmpty
    }
    
    internal var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

extension TriangularRegion {
    
    internal func chunk(for triangle: Triangle) -> C? {
        
        chunks.first {
            
            $0.triangle == triangle
        }
    }
}
