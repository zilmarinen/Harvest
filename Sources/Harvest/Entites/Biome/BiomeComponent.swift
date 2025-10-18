//
//  BiomeComponent.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille
import RealityKit

internal class BiomeComponent: Component,
                               Codable {
    
    internal var vertices: [Triangle.Vertex : BiomeVertex] = [:]
}

internal protocol HasBiomeComponent: Entity {
    
    var biomeComponent: BiomeComponent { get }
    
    var isEmpty: Bool { get }
    
    func get(value vertex: Triangle.Vertex) -> BiomeVertex?
    
    func set(_ biome: Biome,
             _ height: Int,
             for vertex: Triangle.Vertex)
}

extension HasBiomeComponent {
    
    internal var biomeComponent: BiomeComponent {
        
        get {
            
            let component = components[BiomeComponent.self] ?? .init()
            
            if components[BiomeComponent.self] == nil {
                
                components[BiomeComponent.self] = component
            }
            
            return component
        }
        
        set {
            
            components[BiomeComponent.self] = newValue
        }
    }
    
    var isEmpty: Bool { biomeComponent.vertices.isEmpty }
    
    func get(value vertex: Triangle.Vertex) -> BiomeVertex? {
        
        biomeComponent.vertices[vertex]
    }
    
    func set(_ biome: Biome,
             _ elevation: Int,
             for vertex: Triangle.Vertex) {
        
        guard elevation > 0 else {
            
            return biomeComponent.vertices[vertex] = nil
        }
        
        biomeComponent.vertices[vertex] = .init(vertex: vertex,
                                                biome: biome,
                                                elevation: elevation)
    }
}
