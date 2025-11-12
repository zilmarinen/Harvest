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
internal struct FootpathSystem: @preconcurrency System {
    
    internal static var dependencies: [SystemDependency] = [.after(TerrainSystem.self)]
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let biosphere = context.scene.find(entity: .biosphere) as? Biosphere,
              let footpaths = context.scene.find(entity: .footpaths) as? Footpaths else { return }
        
        var emptyRegions: [FootpathRegion] = []
        
        for region in footpaths.dirtyRegions {
            
            for chunk in region.dirtyChunks {
            
                update(chunk: chunk,
                       footpaths: footpaths)
            
                if chunk.isEmpty {
                    
                    chunk.removeFromParent()
                }
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
    
    private func update(chunk: FootpathChunk,
                        footpaths: Footpaths) {
        
        
    }
}
