//
//  CursorVertex.swift
//  Harvest
//
//  Created by Zack Brown on 17/05/2026.
//

import Deltille
import Euclid
import RealityKit

internal class CursorVertex: Entity,
                             HasMesh {
    
    var mesh: Mesh? { Mesh.cursor(.conway) }
    var material: CustomMaterial? { ShaderProgram.shared.material(for: .customMaterial) }
    
    internal required init() {
        
        super.init()
        
        updateModel()
    }
}
