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
        
        hasUniformBiome &&
        hasUniformElevation
    }
    
    internal var hasUniformBiome: Bool {
        
        guard vertices.count == 3 else { return false }
        
        for i in 0..<vertices.count {
            
            if vertices[i].biome != vertices[(i + 1) % vertices.count].biome {
                
                return false
            }
        }
        
        return true
    }
    
    internal var hasUniformElevation: Bool {
        
        guard vertices.count == 3 else { return false }
        
        for i in 0..<vertices.count {
            
            if vertices[i].elevation != vertices[(i + 1) % vertices.count].elevation {
                
                return false
            }
        }
        
        return true
    }
    
    internal var biome: Biome? {
        
        guard hasUniformBiome else { return nil }
        
        return vertices.first?.biome
    }
    
    internal var elevation: Int? {
        
        guard hasUniformElevation else { return nil }
        
        return vertices.first?.elevation
    }
}

extension BiomeTile {
    
    internal func biome(for vertex: Triangle.Vertex) -> BiomeVertex? {
        
        vertices.first {
            
            $0.vertex == vertex
        }
    }
}
