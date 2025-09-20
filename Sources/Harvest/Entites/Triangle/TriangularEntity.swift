//
//  TriangularEntity.swift
//  Harvest
//
//  Created by Zack Brown on 16/09/2025.
//

import Deltille
import RealityKit

public class TriangularEntity: Entity {
    
    internal let triangle: Triangle
    internal let scale: Triangle.Scale
    
    internal init(_ triangle: Triangle,
                  _ scale: Triangle.Scale) {
        
        self.triangle = triangle
        self.scale = scale
        
        super.init()
        
        name = triangle.id
        
        switch scale {
            
        case .region:
            
            position = .init(triangle.position(.region))
            
        case .chunk:
            
            let origin = triangle.transpose(.chunk,
                                            .region).position(.region)
            
            position = .init(triangle.position(.chunk) - origin)
            
        default:
            
            position = .zero
        }
        
        guard let entity = try? ModelEntity(triangle.mesh(scale)) else { return }
        
        entity.position = -.init(triangle.position(scale)) + [0.0, scale == .region ? 0.01 : 0.02, 0.0]
        entity.model?.materials = [SimpleMaterial(color: triangle.isPointy ? .systemMint : .systemPink,
                                                  isMetallic: false)]
        
        addChild(entity)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
}
