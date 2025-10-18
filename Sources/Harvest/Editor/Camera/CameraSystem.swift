//
//  CameraSystem.swift
//
//  Created by Zack Brown on 16/08/2025.
//

import RealityKit

internal struct CameraSystem: System {
    
    private static let query = EntityQuery(where: .has(CameraFocusComponent.self))
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let camera = entity as? Camera,
                  let focus = camera.components[CameraFocusComponent.self],
                  let ortho = camera.pov.components[OrthographicCameraComponent.self] else { return }
            
            camera.position = .init(focus.focus)
            camera.pov.position = -CameraFocusComponent.forward * ortho.scale * 2.0

            camera.pov.look(at: .zero,
                            from: camera.pov.position,
                            relativeTo: camera)
        }
    }
}
