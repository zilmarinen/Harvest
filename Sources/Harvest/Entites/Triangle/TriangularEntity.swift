//
//  TriangularEntity.swift
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
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
}
