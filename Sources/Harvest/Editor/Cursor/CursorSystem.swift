//
//  CursorSystem.swift
//  Harvest
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
            
            let hex = Hexagon(focus.focus,
                              .chunk)
            let region = Triangle(focus.focus,
                                  .region)
            let chunk = Triangle(focus.focus,
                                 .chunk)
            let tile = Triangle(focus.focus,
                                .tile)
            let vertex = Triangle(focus.focus,
                                  .sierpinski)
            
            let hexColor = NSColor.white
            let regionColor: NSColor = region.isPointy ? .red : .green
            let chunkColor: NSColor = chunk.isPointy ? .blue : .yellow
            let tileColor: NSColor = tile.isPointy ? .purple : .orange
            let vertexColor: NSColor = vertex.isPointy ? .gray : .black
            
            cursor.region.position = .init(region.position(.region) + .init(0.0, -0.005, 0.0))
            cursor.hex.position = .init(hex.position(.chunk) + .init(0.0, -0.004, 0.0))
            cursor.chunk.position = .init(chunk.position(.chunk) + .init(0.0, -0.003, 0.0))
            cursor.tile.position = .init(tile.position(.tile) + .init(0.0, -0.002, 0.0))
            cursor.vertex.position = .init(vertex.position(.sierpinski) + .init(0.0, -0.001, 0.0))
            
            cursor.region.transform.rotation = .init(angle: Float(region.rotation),
                                                     axis: [0, 1, 0])
            cursor.chunk.transform.rotation = .init(angle: Float(chunk.rotation),
                                                    axis: [0, 1, 0])
            cursor.tile.transform.rotation = .init(angle: Float(tile.rotation),
                                                   axis: [0, 1, 0])
            cursor.vertex.transform.rotation = .init(angle: Float(vertex.rotation),
                                                     axis: [0, 1, 0])
            
            cursor.hex.model?.materials = [SimpleMaterial(color: hexColor,
                                                             isMetallic: false)]
            cursor.region.model?.materials = [SimpleMaterial(color: regionColor,
                                                             isMetallic: false)]
            cursor.chunk.model?.materials = [SimpleMaterial(color: chunkColor,
                                                            isMetallic: false)]
            cursor.tile.model?.materials = [SimpleMaterial(color: tileColor,
                                                           isMetallic: false)]
            cursor.vertex.model?.materials = [SimpleMaterial(color: vertexColor,
                                                             isMetallic: false)]
            
            let closest = tile.closest(focus.focus,
                                       .tile)
            
            cursor.cursor.position = .init(closest.position(.tile))
        }
    }
}
