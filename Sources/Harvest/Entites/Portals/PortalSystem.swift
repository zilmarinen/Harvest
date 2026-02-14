//
//  PortalSystem.swift
//  Harvest
//
//  Created by Zack Brown on 14/02/2026.
//

import AppKit
import Deltille
import Euclid
import RealityKit

@MainActor
internal struct PortalSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let portals = context.scene.find(entity: .portals) as? Portals,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        portals.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle.sieve(for: .chunk))
            
            return false
        }
    }
}
