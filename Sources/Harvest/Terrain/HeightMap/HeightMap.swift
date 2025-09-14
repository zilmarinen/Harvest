//
//  HeightMap.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import Foundation
import RealityKit

internal class HeightMap: Entity {}

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
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
    
    internal func chunk(for hexagon: Hexagon) -> HeightMapChunk? {
        
        chunks.first {
            
            $0.hexagon == hexagon
        }
    }
    
    internal func chunks(intersecting triangle: Triangle) -> [HeightMapChunk] {
        
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
