//
//  HeightMapChunkComponent.swift
//  Harvest
//
//  Created by Zack Brown on 07/09/2025.
//

import Deltille
import RealityKit

internal class HeightMapChunkComponent: Component,
                                        Codable {
    
    internal var vertices: [Triangle.Vertex : HeightMapVertex] = [:]
    
    internal func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
     
        vertices[vertex]
    }
    
    internal func set(_ height: Int,
                      _ material: Int,
                      for vertex: Triangle.Vertex) {
        
        guard height > 0 else {
            
            return vertices[vertex] = nil
        }
        
        vertices[vertex] = .init(height: height,
                                 material: material)
    }
}

internal protocol HasHeightMapChunkComponent: Entity {
    
    var heightMapChunkComponent: HeightMapChunkComponent { get }
    
    var isEmpty: Bool { get }
    
    func get(value vertex: Triangle.Vertex) -> HeightMapVertex?
    
    func set(_ height: Int,
             _ material: Int,
             for vertex: Triangle.Vertex)
}

extension HasHeightMapChunkComponent {
    
    var isEmpty: Bool { heightMapChunkComponent.vertices.isEmpty }
    
    func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        heightMapChunkComponent.get(value: vertex)
    }
    
    func set(_ height: Int,
             _ material: Int,
             for vertex: Triangle.Vertex) {
        
        heightMapChunkComponent.set(height,
                                    material,
                                    for: vertex)
    }
}
