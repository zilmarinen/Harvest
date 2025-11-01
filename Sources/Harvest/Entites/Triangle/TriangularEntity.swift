//
//  TriangularEntity.swift
//
//  Created by Zack Brown on 16/09/2025.
//

import Deltille
import RealityKit

public class TriangularEntity: Entity,
                               @preconcurrency Codable {
    
    internal enum CodingKeys: CodingKey {
        
        case scale
        case triangle
    }
    
    internal let triangle: Triangle
    internal let scale: Triangle.Scale
    
    internal init(_ triangle: Triangle,
                  _ scale: Triangle.Scale) {
        
        self.triangle = triangle
        self.scale = scale
        
        super.init()
        
        name = triangle.id
        
        reposition()
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.triangle = try container.decode(Triangle.self,
                                             forKey: .triangle)
        
        self.scale = try container.decode(Triangle.Scale.self,
                                          forKey: .scale)
        
        super.init()
        
        name = triangle.id
        
        reposition()
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(triangle,
                             forKey: .triangle)
        
        try container.encode(scale,
                             forKey: .scale)
    }
}

extension TriangularEntity {
    
    private func reposition() {
        
        switch scale {
            
        case .region:
            
            position = .init(triangle.position(scale))
            
        case .chunk:
            
            let origin = triangle.transpose(scale,
                                            .region).position(.region)
            
            position = .init(triangle.position(scale) - origin)
            
        default:
            
            position = .zero
        }
    }
}
