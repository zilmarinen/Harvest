//
//  WaterSystem.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

@MainActor
internal struct WaterSystem: System {
    
    private static let query = EntityQuery(where: .has(WaterComponent.self))
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let biosphere = context.scene.find(entity: .biosphere) as? Biosphere else { return }
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            //
        }
    }
}
