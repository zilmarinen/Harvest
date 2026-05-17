//
//  CameraSystem.swift
//
//  Created by Zack Brown on 16/08/2025.
//

import Euclid
import RealityKit

@MainActor
internal struct CameraSystem: System {
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let camera = context.scene.find(entity: .camera) as? Camera else { return }
        
        let elevation = Angle(degrees: 45.0)
        
        let horizontal = camera.radius * cos(elevation)
        let vertical = camera.radius * sin(elevation)
        
        let x = cos(camera.rotation.radians) * horizontal
        let z = sin(camera.rotation.radians) * horizontal
        
        camera.position = .init(camera.focus)
        camera.pov.position = .init(Float(x),
                                    Float(vertical),
                                    Float(z))

        camera.pov.look(at: .zero,
                        from: camera.pov.position,
                        relativeTo: camera)
    }
}
