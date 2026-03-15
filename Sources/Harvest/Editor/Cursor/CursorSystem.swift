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
        
        let hitTest = cursor.hitTest(scale: .tile)
        
        guard cursor.cursorStyle != .vertex else {
            
            return layout(vertex: cursor.children,
                          terrain: terrain,
                          water: water,
                          hitTest: hitTest)
        }
        
//        let footprint = footprint(for: cursor.cursorStyle,
//                                  hitTest: hitTest)
//        
//        guard let rotation = cursor.rotation else {
//          
//            return layout(footprint: footprint,
//                          terrain: terrain,
//                          water: water)
//        }
//        
//        layout(footprint: footprint.rotate(rotation),
//               terrain: terrain,
//               water: water)
    }
}

extension CursorSystem {
    
    // MARK: Footprint
    
    private func footprint(for style: CursorStyle,
                           hitTest: HitTest) -> Triangle.Footprint {
        
        switch style {
            
        case .footprint(let template):
            
            return .init(hitTest.triangle,
                         template.tiles)
            
        case .hexagonal:
            
            return .init(hitTest.triangle,
                         hitTest.vertex.tiles)
            
        case .triangle:
            
            return .init(hitTest.triangle,
                         [Coordinate.zero])
            
        default: fatalError("Invalid cursor style for footprint")
        }
    }
    
    private func layout(footprint: Triangle.Footprint,
                        terrain: Terrain,
                        water: Water) {
        
    }
    
    // MARK: Vertex
    
    private func layout(vertex cursors: Entity.ChildCollection,
                        terrain: Terrain,
                        water: Water,
                        hitTest: HitTest) {
        
        let biome = terrain.value(for: hitTest.vertex)
        
        let elevation = Double(biome?.elevation ?? 0)
        
        let offset = Vector(0.0,
                            (Terrain.Constant.baseHeight * elevation) +
                            (elevation > 0 ? Terrain.Constant.apexHeight : 0.0),
                            0.0);
        
        cursors.forEach {

            $0.position = .init(hitTest.vertex.position(.tile) + offset)
        }
    }
}
