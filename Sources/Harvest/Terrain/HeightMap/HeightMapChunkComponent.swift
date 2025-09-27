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
}

internal protocol HasHeightMapChunkComponent: Entity {
    
    var heightMapChunkComponent: HeightMapChunkComponent { get }
    
    var isEmpty: Bool { get }
    
    func get(value vertex: Triangle.Vertex) -> HeightMapVertex?
    
    func set(_ height: Int,
             _ material: TerrainType,
             for vertex: Triangle.Vertex)
}

extension HasHeightMapChunkComponent {
    
    internal var heightMapChunkComponent: HeightMapChunkComponent {
        
        get {
            
            let component = components[HeightMapChunkComponent.self] ?? .init()
            
            if components[HeightMapChunkComponent.self] == nil {
                
                components[HeightMapChunkComponent.self] = component
            }
            
            return component
        }
        
        set {
            
            components[HeightMapChunkComponent.self] = newValue
        }
    }
    
    var isEmpty: Bool { heightMapChunkComponent.vertices.isEmpty }
    
    func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        heightMapChunkComponent.vertices[vertex]
    }
    
    func set(_ height: Int,
             _ material: TerrainType,
             for vertex: Triangle.Vertex) {
        
        guard height > 0 else {
            
            return heightMapChunkComponent.vertices[vertex] = nil
        }
        
        heightMapChunkComponent.vertices[vertex] = .init(vertex: vertex,
                                                         height: height,
                                                         material: material)
    }
}
