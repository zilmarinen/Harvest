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
    
    var vertices: [Triangle.Vertex : BiomeVertex] { get }
    
    var isEmpty: Bool { get }
    
    func get(biome vertex: Triangle.Vertex) -> BiomeVertex?
    
    func set(_ biome: Biome,
             _ elevation: Int,
             for vertex: Triangle.Vertex)
    
    func merge(_ other: BiomeComponent)
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
    
    internal var vertices: [Triangle.Vertex : BiomeVertex] { biomeComponent.vertices }
    
    internal var isEmpty: Bool { vertices.isEmpty }
    
    internal func get(biome vertex: Triangle.Vertex) -> BiomeVertex? {
        
        biomeComponent.vertices[vertex]
    }
    
    internal func set(_ biome: Biome,
                      _ elevation: Int,
                      for vertex: Triangle.Vertex) {
        
        guard elevation > 0 else {
            
            return biomeComponent.vertices[vertex] = nil
        }
        
        biomeComponent.vertices[vertex] = .init(vertex: vertex,
                                                biome: biome,
                                                elevation: elevation)
    }
    
    internal func merge(_ other: BiomeComponent) {
        
        biomeComponent.vertices.merge(other.vertices) { (current, _) in current }
    }
}
