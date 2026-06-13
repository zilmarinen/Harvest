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
        
        let elevation = Angle(degrees: 35.264)
        
        let distance = Double(camera.camera.far / 2.0)
        
        let horizontal = distance * cos(elevation)
        let vertical = distance * sin(elevation)
        
        let x = (cos(camera.rotation.radians) * horizontal)
        let z = (sin(camera.rotation.radians) * horizontal)
        
        let position = Vector(camera.focus.x + x,
                              vertical,
                              camera.focus.z + z)

        camera.look(at: .init(camera.focus),
                    from: .init(position),
                    upVector: [0, 1, 0],
                    relativeTo: nil)
    }
}
