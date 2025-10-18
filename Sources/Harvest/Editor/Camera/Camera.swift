//
//  Camera.swift
//
//  Created by Zack Brown on 16/08/2025.
//

import Euclid
import RealityKit

public class Camera: Entity {
    
    internal let pov = PerspectiveCamera()
    
    public required init() {
        
        super.init()
        
        name = Entity.Identifier.camera.id
        
        addChild(pov)
        
        components.set(CameraFocusComponent())
        
        var ortho = OrthographicCameraComponent()
        
        ortho.scale = CameraFocusComponent.maximumRadius
        
        pov.components[OrthographicCameraComponent.self] = ortho
    }
}

extension Camera {
    
    public func focus(on location: Vector) {
        
        components[CameraFocusComponent.self]?.focus = location
    }
    
    public func zoom(delta: Float) {
        
        guard let ortho = pov.components[OrthographicCameraComponent.self] else { return }
        
        let scale = max(CameraFocusComponent.minimumRadius,
                        min(CameraFocusComponent.maximumRadius,
                            ortho.scale + delta))
        
        pov.components[OrthographicCameraComponent.self]?.scale = scale
    }
}
