//
//  FootpathSystem.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

@MainActor
internal struct FootpathSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let biosphere = context.scene.find(entity: .biosphere) as? Biosphere,
              let footpaths = context.scene.find(entity: .footpaths) as? Footpaths else { return }
        
        var emptyRegions: [FootpathRegion] = []
        
        for region in footpaths.dirtyRegions {
            
            for chunk in region.dirtyChunks {
                
//                guard let biomeChunk = biosphere.chunk(for: chunk.hexagon) else {
//                    
//                    chunk.removeFromParent()
//                    
//                    continue
//                }
//            
//                update(chunk: chunk,
//                       biomeChunk: biomeChunk)
            }
            
            if region.isEmpty {
                
                emptyRegions.append(region)
            }
        }
        
        emptyRegions.forEach {
            
            $0.removeFromParent()
        }
    }
}

extension FootpathSystem {
    
//    private func update(chunk: FootpathChunk,
//                        biomeChunk: BiomeChunk) {
//        
//        var mesh = Mesh.empty
//        
//        for vertex in chunk.vertices
//        
//        chunk.mesh = mesh.translated(by: -chunk.hexagon.position(chunk.scale))
//        chunk.isDirty = false
//    }
//    
//    private func render(vertex: Triangle.Vertex) -> Mesh {
//        
//        .empty
//    }
}
