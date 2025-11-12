//
//  FoliageChunk.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import Euclid
import RealityKit

internal class FoliageChunk: TriangularChunk<Triangle>,
                             HasMesh,
                             HasSoilableComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case mesh
    }
    
    internal var mesh: Mesh? {
        
        didSet {
            
            updateModel()
        }
    }
    
    internal var material: CustomMaterial? { ShaderProgram.shared.material(for: .customMaterial) }
    
    required internal init(_ triangle: Triangle) {
        
        super.init(triangle)
    }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.mesh = try container.decode(Mesh.self,
                                         forKey: .mesh)
        
        updateModel()
    }
    
    internal override func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mesh,
                             forKey: .mesh)
    }
}
