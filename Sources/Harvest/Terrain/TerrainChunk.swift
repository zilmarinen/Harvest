//
//  TerrainChunk.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import Euclid
import RealityKit

internal class TerrainChunk: Entity,
                             @preconcurrency Codable {
    
    internal enum CodingKeys: CodingKey {
        
        case triangle
    }
    
    internal let triangle: Triangle
    internal let soilableComponent = SoilableComponent()
    
    internal init(triangle: Triangle) {
        
        self.triangle = triangle
        
        super.init()
        
        position = .init(triangle.position(.chunk) - triangle.transpose(.chunk,
                                                                        .region).position(.region))
        
        components[SoilableComponent.self] = soilableComponent
        
        guard let entity = try? ModelEntity(triangle.mesh(.chunk)) else { return }
        
        entity.position = -.init(triangle.position(.chunk)) + [0.0, 0.01, 0.0]
        entity.model?.materials = [SimpleMaterial(color: triangle.isPointy ? .systemMint : .systemPink,
                                                  isMetallic: false)]
        
        addChild(entity)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.triangle = try container.decode(Triangle.self,
                                             forKey: .triangle)
        
        super.init()
        
        position = .init(triangle.position(.chunk) - triangle.transpose(.chunk,
                                                                        .region).position(.region))
        
        components[SoilableComponent.self] = soilableComponent
        
        guard let entity = try? ModelEntity(triangle.mesh(.chunk)) else { return }
        
        entity.position = -.init(triangle.position(.chunk)) + [0.0, 0.01, 0.0]
        entity.model?.materials = [SimpleMaterial(color: triangle.isPointy ? .systemMint : .systemPink,
                                                  isMetallic: false)]
        
        addChild(entity)
    }
    
    internal func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(triangle, forKey: .triangle)
    }
}
