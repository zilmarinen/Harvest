//
//  FootpathChunk.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import Deltille
import Euclid
import Lattice
import RealityKit

public class FootpathChunk: TriangularChunk,
                            HasMesh {
    
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
        
        let objString = try container.decode(String.self,
                                                     forKey: .mesh)
                
        self.mesh = Mesh(objString: objString)
        
        updateModel()
    }
    
    public override func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mesh?.objString(),
                             forKey: .mesh)
    }
}
