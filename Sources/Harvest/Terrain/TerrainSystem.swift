//
//  TerrainSystem.swift
//  Harvest
//
//  Created by Zack Brown on 27/08/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

internal struct TerrainSystem: System {
    
    private static let query = EntityQuery(where: .has(TerrainComponent.self))
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let terrain = entity as? Terrain else { continue }
            
//            for chunk in terrain.dirtyChunks {
//                
//                print("Updating chunk: \(chunk.triangle.id)")
//                
//                let sieve = chunk.triangle.sieve(for: .chunk)
//                
//                chunk.children.forEach { $0.removeFromParent() }
//                
//                for vertex in sieve.vertices {
//                    
//                    guard let heightMap = terrain.get(value: vertex) else { continue }
//                    
//                    let entity = ModelEntity(mesh: .generateBox(size: 0.25),
//                                             materials: [SimpleMaterial(color: chunk.triangle.isPointy ? .black : .white,
//                                                                        isMetallic: false)])
//                    
//                    entity.position = .init(vertex.position(.tile)) - chunk.position + [0, Float(heightMap.height) * 0.1, 0]
//                    
//                    chunk.addChild(entity)
//                }
//                
//                chunk.soilableComponent.isDirty = false
//            }
        }
    }
}
