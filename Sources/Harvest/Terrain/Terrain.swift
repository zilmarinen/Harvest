//
//  Terrain.swift
//  Harvest
//
//  Created by Zack Brown on 10/08/2025.
//

import Deltille
import RealityKit

public class Terrain: Entity {
    
    internal let heightMap = HeightMap()
    
    internal required init() {
        
        super.init()
        
        addChild(heightMap)
        
        components[TerrainComponent.self] = .init()
    }
}

extension Terrain {
    
    internal var chunks: [TerrainChunk] {
        
        children.compactMap {
            
            $0 as? TerrainChunk
        }
    }
 
    internal var dirtyChunks: [TerrainChunk] {
        
        chunks.filter { $0.isDirty }
    }
}

extension Terrain {
    
    public func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        heightMap.get(value: vertex)
    }
    
    public func set(_ height: Int,
                    _ material: Int,
                    for vertex: Triangle.Vertex) {
        
        heightMap.set(height,
                      material,
                      for: vertex)
        
        for tile in vertex.tiles {
            
            let triangle = Triangle(tile.vertex.position(.tile),
                                    .chunk)
            
            let chunk = chunk(for: triangle) ?? TerrainChunk(triangle: triangle)
            
            if chunk.parent == nil {
                
                addChild(chunk)
            }
            
            chunk.becomeDirty()
        }
    }
    
    internal func chunk(for triangle: Triangle) -> TerrainChunk? {
        
        chunks.first {
            
            $0.triangle == triangle
        }
    }
}

internal class TerrainComponent: Component {
    
    
}
