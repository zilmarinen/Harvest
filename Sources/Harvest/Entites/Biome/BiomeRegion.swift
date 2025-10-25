//
//  BiomeRegion.swift
//
//  Created by Zack Brown on 24/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class BiomeRegion: HexagonalRegion<BiomeChunk> {
    
    internal init(hexagon: Hexagon) {
        
        super.init(hexagon,
                   .region)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    internal func merge(_ chunk: BiomeChunk) {
        
        guard let existing = self.chunk(for: chunk.hexagon) else {
        
            addChild(chunk)
            
            return
        }
        
        existing.merge(chunk.biomeComponent)
    }
}

extension BiomeRegion {
    
    internal func get(biome vertex: Triangle.Vertex) -> BiomeVertex? {
     
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon) else { return nil }
        
        return chunk.get(biome: vertex)
    }
    
    internal func set(_ biome: Biome,
                      _ elevation: Int,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon) ?? BiomeChunk(hexagon)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(biome,
                  elevation,
                  for: vertex)
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
}
