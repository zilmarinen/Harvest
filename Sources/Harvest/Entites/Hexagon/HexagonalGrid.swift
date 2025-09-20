//
//  HexagonalGrid.swift
//  Harvest
//
//  Created by Zack Brown on 17/09/2025.
//

import Deltille
import RealityKit

internal class HexagonalGrid<C: HexagonalEntity>: Entity {
    
    internal var isEmpty: Bool {
        
        chunks.isEmpty
    }
    
    internal var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

extension HexagonalGrid {
    
    internal func chunk(for hexagon: Hexagon) -> C? {
        
        chunks.first {
            
            $0.hexagon == hexagon
        }
    }
    
    internal func chunks(intersecting triangle: Triangle) -> [C] {
        
        chunks.filter {
            
            for vertex in $0.hexagon.vertices {
                
                let other = Triangle(vertex.position(.chunk),
                                     .region)
                
                if other == triangle {
                    
                    return true
                }
            }
            
            for vertex in triangle.vertices {
                
                let other = Hexagon(vertex.position(.region),
                                    .chunk)
                
                if other == $0.hexagon {
                    
                    return true
                }
            }
            
            return false
        }
    }
}
