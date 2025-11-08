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
    
    internal var hasThreeVertices: Bool { vertices.count == 3 }
    
    internal var hasUniformBiome: Bool {
        
        guard hasThreeVertices else { return false }
        
        for i in 0..<vertices.count {
            
            if vertices[i].biome != vertices[(i + 1) % vertices.count].biome {
                
                return false
            }
        }
        
        return true
    }
    
    internal var hasUniformElevation: Bool {
        
        guard hasThreeVertices else { return false }
        
        for i in 0..<vertices.count {
            
            if vertices[i].elevation != vertices[(i + 1) % vertices.count].elevation {
                
                return false
            }
        }
        
        return true
    }
    
    internal var uniformBiome: Biome? {
        
        guard hasUniformBiome else { return nil }
        
        return vertices.first?.biome
    }
    
    internal var uniformElevation: Int? {
        
        guard hasUniformElevation else { return nil }
        
        return vertices.first?.elevation
    }
    
    internal var apex: Int {
        
        let elevation = vertices.map { $0.elevation }
        
        return elevation.sorted(by: >).first ?? 0
    }
    
    internal var base: Int {
        
        guard hasThreeVertices else { return 0 }
        
        let elevation = vertices.map { $0.elevation }
        
        return elevation.sorted(by: <).first ?? 0
    }
}

extension BiomeTile {
    
    internal func biome(for vertex: Triangle.Vertex) -> BiomeVertex? {
        
        vertices.first {
            
            $0.vertex == vertex
        }
    }
}
