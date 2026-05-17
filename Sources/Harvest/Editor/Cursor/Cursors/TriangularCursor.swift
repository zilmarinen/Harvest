//
//  TriangularCursor.swift
//  Harvest
//
//  Created by Zack Brown on 17/05/2026.
//

import Deltille
import Euclid
import RealityKit

internal class TriangularCursor: Entity {
    
    internal let vertices: [CursorVertex]
    
    internal required init() {
        
        let triangle = Triangle.zero
        
        self.vertices = triangle.vertices.map {
            
            let cursor = CursorVertex()
            
            cursor.position = .init($0.position(.tile))
            
            return cursor
        }
        
        super.init()
        
        vertices.forEach {
            
            addChild($0)
        }
    }
}

extension TriangularCursor {
    
    internal func set(elevation: Double,
                      at index: Int) {
        
        let position = vertices[index].position
        
        vertices[index].position = .init(position.x,
                                         Float(elevation),
                                         position.z)
    }
}
