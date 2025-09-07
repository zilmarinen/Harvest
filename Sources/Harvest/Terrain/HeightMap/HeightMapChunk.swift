//
//  HeightMapChunk.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import RealityKit

internal class HeightMapChunk: Entity {
    
    internal let hexagon: Hexagon
    
    init(hexagon: Hexagon) {
        
        self.hexagon = hexagon
        
        super.init()
        print("Creating new height map chunk: \(hexagon.id)")
        position = .init(hexagon.position(.chunk))
        
        components[HeightMapChunkDataComponent.self] = .init()
        
        let material = SimpleMaterial(color: .yellow,
                                      isMetallic: false)
        
        guard let entity = try? ModelEntity(hexagon.mesh(.chunk)) else { return }
        
        entity.position = .init(0.0, 0.004, 0.0) - position
        entity.components[ModelComponent.self]?.materials = [material]
        
        addChild(entity)
    }
    
    @available(*, unavailable)
    @MainActor @preconcurrency required init() { fatalError("init() has not been implemented") }
}

extension HeightMapChunk {
    
    internal func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        guard let heightMap = components[HeightMapChunkDataComponent.self] else { return nil }
                
        return heightMap.vertices[vertex]
    }
    
    internal func set(_ height: Int,
                      _ material: Int,
                      for vertex: Triangle.Vertex) {
        
        guard let heightMap = components[HeightMapChunkDataComponent.self] else { return }
        
        heightMap.set(height,
                      material,
                      for: vertex)
    }
}


internal class HeightMapChunkDataComponent: Component {
    
    internal var vertices: [Triangle.Vertex : HeightMapVertex] = [:]
    
    internal func set(_ height: Int,
                      _ material: Int,
                      for vertex: Triangle.Vertex) {
        
        vertices[vertex] = .init(height: height,
                                 material: material)
    }
}
