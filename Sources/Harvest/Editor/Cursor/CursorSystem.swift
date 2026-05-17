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
        
        guard let cursor = context.scene.find(entity: .cursor) as? Cursor,
              let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let water = context.scene.find(entity: .water) as? Water else { return }
        
        switch cursor.cursorStyle {
            
        case .footprint:
            
            layout(footprint: cursor,
                   terrain: terrain,
                   water: water)
            
        case .triangle:
            
            layout(triangle: cursor,
                   terrain: terrain,
                   water: water)
            
        case .hexagonal,
             .vertex:
            
            layout(hexagon: cursor,
                   terrain: terrain,
                   water: water,
                   hexagonal: cursor.cursorStyle == .hexagonal)
        }
    }
}

extension CursorSystem {
    
    private func elevation(triangle: Triangle,
                           terrain: Terrain,
                           water: Water) -> Double {
        
        guard let value = water.value(for: triangle.vertex) else {
            
            for vertex in triangle.vertices {
                
                guard let value = terrain.value(for: vertex) else { continue }
                
                return Terrain.apex(for: value.elevation)
            }
            
            return 0.0
        }
        
        return Water.apex(for: value.elevation)
    }
    
    private func elevation(vertex: Triangle.Vertex,
                           terrain: Terrain,
                           water: Water) -> Double {
        
        for triangle in vertex.tiles {
            
            guard let value = water.value(for: triangle.vertex) else { continue }
            
            return Water.apex(for: value.elevation)
        }
        
        guard let value = terrain.value(for: vertex) else { return 0.0 }
        
        return Terrain.apex(for: value.elevation)
    }
    
    private func layout(footprint cursor: Cursor,
                        terrain: Terrain,
                        water: Water) {
        
        let triangle = cursor.triangle
        
        cursor.position = .init(triangle.position(.tile))
        
        let elevation = elevation(triangle: triangle,
                                  terrain: terrain,
                                  water: water)
        
        let rotation = simd_quatf(angle: Float(triangle.orientation - cursor.rotation.radians),
                                  axis: .init(.unitY))
        
        let translation = SIMD3<Float>(0.0,
                                       Float(elevation),
                                       0.0)
        
        cursor.blueprint.transform = .init(rotation: rotation,
                                           translation: translation)
    }
    
    private func layout(triangle cursor: Cursor,
                        terrain: Terrain,
                        water: Water) {
        
        let triangle = cursor.triangle
        
        let rotation = simd_quatf(angle: Float(triangle.orientation),
                                  axis: .init(.unitY))
        
        let translation = SIMD3<Float>(triangle.position(.tile))
        
        cursor.transform = .init(rotation: rotation,
                                 translation: translation)
        
        for i in triangle.vertices.indices {
            
            let connected = triangle.vertices[i]
            
            let elevation = self.elevation(vertex: connected,
                                           terrain: terrain,
                                           water: water)
            
            cursor.triangular.set(elevation: elevation,
                                  at: i)
        }
    }
    
    private func layout(hexagon cursor: Cursor,
                        terrain: Terrain,
                        water: Water,
                        hexagonal: Bool) {
        
        let vertex = cursor.vertex
        
        cursor.position = .init(vertex.position(.tile))
        
        var elevation = elevation(vertex: vertex,
                                  terrain: terrain,
                                  water: water)
        
        cursor.hexagonal.set(origin: elevation)
        
        guard hexagonal else { return }
        
        for i in vertex.vertices.indices {
            
            let connected = vertex.vertices[i]
            
            elevation = self.elevation(vertex: connected,
                                       terrain: terrain,
                                       water: water)
            
            cursor.hexagonal.set(elevation: elevation,
                                 at: i)
        }
    }
}
