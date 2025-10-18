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
                  let focus = cursor.components[CursorComponent.self] else { return }
            let tile = Triangle(focus.focus,
                                .tile)
            
            let closest = tile.closest(focus.focus,
                                       .tile)
            
            let baseHeight = TerrainCacheComponent.baseHeight
            let apexHeight = TerrainCacheComponent.apexHeight
            
            let elevation = Int(focus.focus.y / TerrainCacheComponent.baseHeight)
            let offset = Vector(0.0, (Double(elevation) * baseHeight) + apexHeight, 0.0)
            
            cursor.cursor.position = .init(closest.position(.tile) + offset)
        }
    }
}
