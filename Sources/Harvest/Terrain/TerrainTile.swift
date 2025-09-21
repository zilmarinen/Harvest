//
//  TerrainTile.swift
//  Harvest
//
//  Created by Zack Brown on 20/09/2025.
//

import Deltille

internal struct TerrainTile {
    
    internal let triangle: Triangle
    internal let vertices: [HeightMapVertex]
}

extension TerrainTile {
    
    internal var isUniform: Bool {
        
        guard vertices.count == 3 else { return false }
        
        for i in 0..<(vertices.count - 1) {
            
            let lhs = vertices[i]
            let rhs = vertices[i + 1]
            
            if lhs.height != rhs.height ||
               lhs.material != rhs.material {
                
                return false
            }
        }
        
        return true
    }
    
    internal var anyHeight: Int {
        
        vertices.first?.height ?? 0
    }
    
    internal var anyMaterial: Int {
        
        vertices.first?.material ?? 0
    }
}

extension TerrainTile {
    
    internal func heightMap(vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        vertices.first {
            
            $0.vertex == vertex
        }
    }
}
