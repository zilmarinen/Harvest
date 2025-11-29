//
//  CursorSystem.swift
//
//  Created by Zack Brown on 18/08/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

@MainActor
internal struct CursorSystem: System {
    
    private static let query = EntityQuery(where: .has(CursorComponent.self))
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let water = context.scene.find(entity: .water) as? Water else { return }
        
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
                                    terrain: terrain,
                                    hexagonal: vertex)
                
            case .triangle: update(cursors: cursor.children,
                                   terrain: terrain,
                                   triangle: triangle)
                
            case .vertex: update(cursors: cursor.children,
                                 terrain: terrain,
                                 vertex: vertex)
            }
        }
    }
}

extension CursorSystem {
    
    private func layout(cursors: Entity.ChildCollection,
                        terrain: Terrain,
                        hexagonal vertex: Triangle.Vertex) {
        
        for i in vertex.vertices.indices {
            
            let child = cursors[i + 1]
            
            let vertex = vertex.vertices[i]
            
            let biome = terrain.value(for: vertex)
            
            let elevation = Double(biome?.elevation ?? 0)
            
            let offset = Vector(0.0,
                                (TerrainSystem.Constant.baseHeight * elevation) +
                                (elevation > 0 ? TerrainSystem.Constant.apexHeight : 0.0),
                                0.0);
            
            child.position = .init(vertex.position(.tile) + offset)
        }
        
        cursors.first?.position = .init(vertex.position(.tile))
    }
    
    private func update(cursors: Entity.ChildCollection,
                        terrain: Terrain,
                        triangle: Triangle) {
        
        for i in cursors.indices {
            
            let child = cursors[i]
            
            let vertex = triangle.vertices[i % triangle.vertices.count]
            
            let biome = terrain.value(for: vertex)
            
            let elevation = Double(biome?.elevation ?? 0)
            
            let offset = Vector(0.0,
                                (TerrainSystem.Constant.baseHeight * elevation) +
                                (elevation > 0 ? TerrainSystem.Constant.apexHeight : 0.0),
                                0.0);
            
            child.position = .init(vertex.position(.tile) + offset)
        }
    }
    
    private func update(cursors: Entity.ChildCollection,
                        terrain: Terrain,
                        vertex: Triangle.Vertex) {
        
        let biome = terrain.value(for: vertex)
        
        let elevation = Double(biome?.elevation ?? 0)
        
        let offset = Vector(0.0,
                            (TerrainSystem.Constant.baseHeight * elevation) +
                            (elevation > 0 ? TerrainSystem.Constant.apexHeight : 0.0),
                            0.0);
        
        cursors.forEach {

            $0.position = .init(vertex.position(.tile) + offset)
        }
    }
}
