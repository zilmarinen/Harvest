//
//  WaterChunk.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Euclid
import RealityKit

internal class WaterChunk: TriangularEntity,
                           HasCollision,
                           HasMesh,
                           HasSoilableComponent,
                           HasWaterComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case tiles
        case mesh
    }
    
    internal var mesh: Mesh? {
        
        didSet {
            
            updateModel()
        }
    }
    
    internal var material: CustomMaterial? { ShaderProgram.shared.material(for: .water) }
    
    internal init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .chunk)
    }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.waterComponent = try container.decode(WaterComponent.self,
                                                   forKey: .tiles)
        
        self.mesh = try container.decode(Mesh.self,
                                         forKey: .mesh)
        
        updateModel()
    }
    
    internal override func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(waterComponent,
                             forKey: .tiles)
        
        try container.encode(mesh,
                             forKey: .mesh)
    }
}
