//
//  BiomeTile.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille

internal struct BiomeTile {
    
    internal let triangle: Triangle
    internal let vertices: [BiomeVertex]
}

extension BiomeTile {
    
    internal var isUniform: Bool {
        
        guard vertices.count == 3 else { return false }
        
        return hasUniformElevation && hasUniformBiome
    }
    
    internal var hasUniformElevation: Bool {
        
        for i in 0..<(vertices.count - 1) {
            
            if vertices[i].elevation != vertices[i + 1].elevation {
                
                return false
            }
        }
        
        return true
    }
    
    internal var hasUniformBiome: Bool {
        
        for i in 0..<(vertices.count - 1) {
            
            if vertices[i].biome != vertices[i + 1].biome {
                
                return false
            }
        }
        
        return true
    }
    
    internal var uniformElevation: Int {
        
        vertices[0].elevation
    }
    
    internal var uniformBiome: Biome {
        
        vertices[0].biome
    }
}

extension BiomeTile {
    
    internal func biome(for vertex: Triangle.Vertex) -> BiomeVertex? {
        
        vertices.first {
            
            $0.vertex == vertex
        }
    }
}
