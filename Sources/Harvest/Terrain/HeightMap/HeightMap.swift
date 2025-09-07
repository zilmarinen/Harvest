//
//  HeightMap.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import RealityKit

internal class HeightMap: Entity {
    
}

extension HeightMap {
    
    internal var chunks: [HeightMapChunk] {
        
        children.compactMap {
            
            $0 as? HeightMapChunk
        }
    }
}

extension HeightMap {
    
    internal func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon) else { return nil }
        
        return chunk.get(value: vertex)
    }
    
    internal func set(_ height: Int,
                      _ material: Int,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon) ?? HeightMapChunk(hexagon: hexagon)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(height,
                  material,
                  for: vertex)
    }
    
    internal func chunk(for hexagon: Hexagon) -> HeightMapChunk? {
        
        chunks.first {
            
            $0.hexagon == hexagon
        }
    }
}
