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
        
        return hasUniformHeight && hasUniformMaterial
    }
    
    internal var hasUniformHeight: Bool {
        
        for i in 0..<(vertices.count - 1) {
            
            if vertices[i].height != vertices[i + 1].height {
                
                return false
            }
        }
        
        return true
    }
    
    internal var hasUniformMaterial: Bool {
        
        for i in 0..<(vertices.count - 1) {
            
            if vertices[i].material != vertices[i + 1].material {
                
                return false
            }
        }
        
        return true
    }
    
    internal var uniformHeight: Int {
        
        vertices[0].height
    }
    
    internal var uniformMaterial: TerrainType {
        
        vertices[0].material
    }
}

extension TerrainTile {
    
    internal func heightMap(vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        vertices.first {
            
            $0.vertex == vertex
        }
    }
}
