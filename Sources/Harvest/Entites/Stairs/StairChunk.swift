//
//  StairChunk.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import Euclid
import Newel
import RealityKit

internal class StairChunk: TriangularChunk<Stoop>,
                           HasMesh {
    
    internal var mesh: Mesh? {
        
        didSet {
            
            updateModel()
        }
    }
    
    internal var material: CustomMaterial? { ShaderProgram.shared.material(for: .customMaterial) }
}
