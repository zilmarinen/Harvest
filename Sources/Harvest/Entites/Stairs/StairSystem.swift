//
//  StairSystem.swift
//
//  Created by Zack Brown on 16/11/2025.
//

import AppKit
import Deltille
import Euclid
import Newel
import RealityKit

@MainActor
internal struct StairSystem: System {
    
    internal enum Constant {
        
        static let apexHeight = 0.1
        static let baseHeight = 0.5
    }
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let stairs = context.scene.find(entity: .stairs) as? Stairs else { return }
        
//        var emptyRegions: [StairRegion] = []
//        
//        for region in stairs.dirtyRegions {
//            
//            var emptyChunks: [StairChunk] = []
//            
//            for chunk in region.dirtyChunks {
//                
//                let slice = terrain.slice(for: chunk.triangle,
//                                          .chunk)
//                
//                guard !slice.vertices.isEmpty else {
//                    
//                    emptyChunks.append(chunk)
//                    
//                    continue
//                }
//                
//                update(chunk: chunk,
//                       terrain: terrain)
//            }
//            
//            emptyChunks.forEach {
//                
//                $0.removeFromParent()
//            }
//            
//            if region.isEmpty {
//                
//                emptyRegions.append(region)
//            }
//        }
//        
//        emptyRegions.forEach {
//            
//            $0.removeFromParent()
//        }
    }
}

extension StairSystem {
    
//    private func update(chunk: StairChunk,
//                        terrain: Terrain) {
//        
//        var mesh = Mesh.empty
//        
//        for (triangle, stoop) in chunk.data {
//            
//            let biome = terrain.tile(for: triangle)
//            
//            let apexElevation = Vector(0.0, (Double(biome.base) * TerrainSystem.Constant.baseHeight) + TerrainSystem.Constant.apexHeight, 0.0)
//            
//            let angle = Angle(radians: biome.triangle.rotation)
//            let rotation = Rotation.yaw(angle)
//            
//            let stairs = Mesh.staircase(stoop,
//                                        7,
//                                        TerrainSystem.Constant.baseHeight,
//                                        .ascending)
//            
//            mesh = mesh.merge(stairs.rotated(by: rotation).translated(by: triangle.position(.tile) + apexElevation))
//        }
//        
//        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
//    }
}
