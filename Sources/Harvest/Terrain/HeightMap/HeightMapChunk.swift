//
//  HeightMapChunk.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import RealityKit

internal class HeightMapChunk: Entity,
                               @preconcurrency Codable,
                               HasHeightMapChunkComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case hexagon
        case vertices
    }
    
    internal let hexagon: Hexagon
    internal let heightMapChunkComponent = HeightMapChunkComponent()
    
    internal init(hexagon: Hexagon) {
        
        self.hexagon = hexagon
        
        super.init()
        
        position = .init(hexagon.position(.chunk))
        
        components[HeightMapChunkComponent.self] = heightMapChunkComponent
        
        guard let entity = try? ModelEntity(Hexagon.zero.mesh(.chunk)) else { return }
        
        entity.position = [0.0, 0.02, 0.0]
        entity.model?.materials = [SimpleMaterial(color: .yellow,
                                                  isMetallic: false)]
        
        addChild(entity)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    internal required init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.hexagon = try container.decode(Hexagon.self, forKey: .hexagon)
        
        super.init()
        
        position = .init(hexagon.position(.chunk))
        
        components[HeightMapChunkComponent.self] = heightMapChunkComponent
        
        guard let entity = try? ModelEntity(Hexagon.zero.mesh(.chunk)) else { return }
        
        entity.position = [0.0, 0.02, 0.0]
        entity.model?.materials = [SimpleMaterial(color: .yellow,
                                                  isMetallic: false)]
        
        addChild(entity)
    }
    
    internal func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hexagon, forKey: .hexagon)
        try container.encode(heightMapChunkComponent.vertices, forKey: .vertices)
    }
}

extension HeightMapChunk {
    
    internal func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        heightMapChunkComponent.vertices[vertex]
    }
    
    internal func set(_ height: Int,
                      _ material: Int,
                      for vertex: Triangle.Vertex) {
        
        heightMapChunkComponent.set(height,
                                    material,
                                    for: vertex)
    }
}
