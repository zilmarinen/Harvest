//
//  OrthographicCameraSystem.swift
//
//  Created by Zack Brown on 16/08/2025.
//

import Euclid
import RealityKit

@MainActor
internal struct CameraSystem: System {
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let camera = context.scene.find(entity: .camera) as? OrthographicCamera else { return }
        
        let elevation = Angle(degrees: 45.0)//35.264
        
        let scale = Double(10.0)
        
        let horizontal = scale * cos(elevation)
        let vertical = scale * sin(elevation)
        
        let x = (cos(camera.rotation.radians) * horizontal)
        let z = (sin(camera.rotation.radians) * horizontal)
        
        let position = Vector(camera.focus.x + x,
                              vertical,
                              camera.focus.z + z)

        camera.look(at: .init(camera.focus),
                    from: .init(position),
                    upVector: .init(0.0, 1.0, 0.0),
                    relativeTo: nil)
    }
}
