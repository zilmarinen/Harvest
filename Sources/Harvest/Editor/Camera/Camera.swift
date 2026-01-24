//
//  Camera.swift
//
//  Created by Zack Brown on 16/08/2025.
//

import RealityKit

internal class Camera: Entity,
                       HasCameraComponent {
    
    internal let pov = PerspectiveCamera()
    
    public required init() {
        
        super.init()
        
        name = Entity.Identifier.camera.id
        
        addChild(pov)
    }
}
