//
//  FoliageChunk.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import Euclid
import RealityKit

internal class FoliageChunk: TriangularEntity,
                             @preconcurrency Codable,
                             HasCollision,
                             HasModel,
                             HasFoliageComponent,
                             HasSoilableComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case triangle
    }
    
    internal init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .chunk)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let triangle = try container.decode(Triangle.self,
                                            forKey: .triangle)
        
        super.init(triangle,
                   .chunk)
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(triangle,
                             forKey: .triangle)
    }
}
