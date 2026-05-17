//
//  VertexCursor.swift
//  Harvest
//
//  Created by Zack Brown on 17/05/2026.
//

import Deltille
import Euclid
import RealityKit

internal class VertexCursor: Entity {
    
    internal enum Mode: String,
                        CaseIterable,
                        Identifiable,
                        Sendable {
        
        case hexagon
        case vertex
        
        public var id: String { rawValue.capitalized }
    }
    
    internal let origin = CursorVertex()
    
    internal let vertices: [CursorVertex]
    
    internal var mode: Mode = .vertex
    
    internal required init() {
        
        let vertex = Triangle.Vertex.zero
        
        self.vertices = vertex.vertices.map {
            
            let cursor = CursorVertex()
            
            cursor.position = .init($0.position(.tile))
            
            return cursor
        }
        
        super.init()
        
        addChild(origin)
        
        vertices.forEach {
            
            addChild($0)
        }
    }
}

extension VertexCursor {
    
    internal func set(mode value: Mode) {
        
        self.mode = value
        
        vertices.forEach {
            
            $0.isEnabled = mode == .hexagon
        }
    }
    
    internal func set(origin elevation: Double) {
        
        origin.position = .init(origin.position.x,
                                Float(elevation),
                                origin.position.z)
    }
    
    internal func set(elevation: Double,
                      at index: Int) {
        
        let position = vertices[index].position
        
        vertices[index].position = .init(position.x,
                                         Float(elevation),
                                         position.z)
    }
}
