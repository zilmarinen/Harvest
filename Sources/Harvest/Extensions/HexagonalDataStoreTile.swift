//
//  HexagonalDataStoreTile.swift
//  Harvest
//
//  Created by Zack Brown on 13/03/2026.
//

import Deltille
import Lattice

// MARK: Terrain

extension HexagonalDataStoreTile where V == TerrainVertex {
    
    internal var apex: Int {

        let values = vertices.map {
            
            $0.value.elevation
        }

        return values.sorted(by: >).first ?? 0
    }

    internal var base: Int {

        let values = vertices.map {
            
            $0.value.elevation
        }

        return values.sorted(by: <).first ?? 0
    }
}

//extension HexagonalDataStoreTile where V == TerrainVertex {
//    
//    internal var hasThreeVertices: Bool {
//        
//        vertices.count == 3
//    }
//    
//    internal var isUniform: Bool {
//        
//        hasUniformBiome &&
//        hasUniformElevation
//    }
//    
//    internal var hasUniformBiome: Bool {
//        
//        guard hasThreeVertices else { return false }
//        
//        let values = Set(vertices.map { $0.value.biome })
//        
//        return values.count == 1
//    }
//    
//    internal var hasUniformElevation: Bool {
//        
//        guard hasThreeVertices else { return false }
//        
//        let values = Set(vertices.map { $0.value.elevation })
//        
//        return values.count == 1
//    }
//    
//    internal var uniformBiome: Biome? {
//        
//        guard hasUniformBiome else { return nil }
//        
//        return vertices.first?.value.biome
//    }
//    
//    internal var uniformElevation: Int? {
//        
//        guard hasUniformElevation else { return nil }
//        
//        return vertices.first?.value.elevation
//    }
//    
//    internal var apex: Int {
//        
//        let values = vertices.map { $0.value.elevation }
//        
//        return values.sorted(by: >).first ?? 0
//    }
//    
//    internal var base: Int {
//        
//        guard hasThreeVertices else { return 0 }
//        
//        let values = vertices.map { $0.value.elevation }
//        
//        return values.sorted(by: <).first ?? 0
//    }
//}
//
//extension HexagonalDataStoreTile where V == TerrainVertex {
//    
//    internal func biome(for vertex: Triangle.Vertex) -> V? {
//        
//        vertices[vertex]
//    }
//}
//
