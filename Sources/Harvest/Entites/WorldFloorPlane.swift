//
//  WorldFloorPlane.swift
//  Harvest
//
//  Created by Zack Brown on 10/04/2026.
//

import Euclid
import RealityKit

internal class WorldFloorPlane: Entity,
                                HasMesh {
    
    internal var mesh: Mesh?
    
    internal var material: CustomMaterial? {
        
        ShaderProgram.shared.material(for: .grid)
    }
    
    internal required init() {
        
        super.init()
        
        let size = 1000.0
        
        let vectors = [Vector(-size, 0.0, size),
                       Vector(size, 0.0, size),
                       Vector(size, 0.0, -size),
                       Vector(-size, 0.0, -size)]
        
        let vertices = vectors.map {
            
            Vertex($0,
                   .unitY,
                   nil,
                   nil)
        }
        
        guard let polygon = Polygon(vertices) else { return }
        
        self.mesh = Mesh([polygon])
        
        updateModel()
    }
}
