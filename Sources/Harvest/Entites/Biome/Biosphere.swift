//
//  Biosphere.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class Biosphere: HexagonalGrid<BiomeRegion,
                                        BiomeChunk> {
    
    internal required init() {
        
        super.init()
        
        name = Entity.Identifier.biosphere.id
    }
    
    internal func merge(_ chunks: [BiomeChunk]) {
        
        chunks.forEach {
            
            let parent = $0.hexagon.parent()
            
            let region = region(for: parent) ?? BiomeRegion(hexagon: parent)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
        }
    }
}

extension Biosphere {
    
    internal func get(biome vertex: Triangle.Vertex) -> BiomeVertex? {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let region = region(for: hexagon.parent()) else { return nil }
        
        return region.get(biome: vertex)
    }
    
    internal func set(_ biome: Biome,
                      _ elevation: Int,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let parent = hexagon.parent()
        
        let region = region(for: parent) ?? BiomeRegion(hexagon: parent)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(biome,
                   elevation,
                   for: vertex)
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
    
    internal func slice(for chunk: Triangle) -> BiomeSlice {
        
        let sieve = chunk.sieve(for: .chunk)
        
        let vertices = sieve.vertices.reduce(into: [Triangle.Vertex : BiomeVertex]()) { result, vertex in
            
            guard let biome = get(biome: vertex) else { return }
            
            result[vertex] = biome
        }
        
        return .init(sieve: sieve,
                     vertices: vertices)
    }
    
    internal func tile(for triangle: Triangle) -> BiomeTile {
        
        let vertices = triangle.vertices.compactMap {
            
            get(biome: $0)
        }
        
        return .init(triangle: triangle,
                     vertices: vertices)
    }
}
