//
//  CursorSystem.swift
//
//  Created by Zack Brown on 18/08/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

internal struct CursorSystem: System {
    
    private static let query = EntityQuery(where: .has(CursorComponent.self))
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let cursor = entity as? Cursor,
                  let component = cursor.components[CursorComponent.self] else { return }
            
            let triangle = Triangle(component.focus,
                                    .tile)
            
            let vertex = triangle.closest(component.focus,
                                      .tile)
            
            switch component.cursorStyle {
                
            case .hexagonal: layout(cursors: cursor.children,
                                    hexagonal: vertex)
                
            case .triangle: update(cursors: cursor.children,
                                   triangle: triangle)
                
            case .vertex: update(cursors: cursor.children,
                                 vertex: vertex)
            }
        }
    }
}

extension CursorSystem {
    
    private func layout(cursors: Entity.ChildCollection,
                        hexagonal vertex: Triangle.Vertex) {
        
        for i in vertex.vertices.indices {
            
            let child = cursors[i + 1]
            
            let vertex = vertex.vertices[i]
            
            child.position = .init(vertex.position(.tile))
        }
        
        cursors.first?.position = .init(vertex.position(.tile))
    }
    
    private func update(cursors: Entity.ChildCollection,
                        triangle: Triangle) {
        
        for i in cursors.indices {
            
            let child = cursors[i]
            
            let vertex = triangle.vertices[i % triangle.vertices.count]
            
            child.position = .init(vertex.position(.tile))
        }
    }
    
    private func update(cursors: Entity.ChildCollection,
                        vertex: Triangle.Vertex) {
        
        cursors.forEach {

            $0.position = .init(vertex.position(.tile))
        }
    }
}
