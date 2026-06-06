//
//  Camera.swift
//
//  Created by Zack Brown on 16/08/2025.
//

import Deltille
import Euclid
import RealityKit

@MainActor
internal class OrthographicCamera: Entity,
                                   HasOrthographicCamera {
    
    internal var camera: OrthographicCameraComponent
    
    internal var focus: Vector = .zero
    internal var rotation: Hexagon.Rotation = .identity
    internal var zoom: Float = 0.0
    
    required init() {
        
        camera = .init()
        
        super.init()
        
        name = Entity.Identifier.camera.id
        
        camera.scale = 10.0
        
        components.set(camera)
    }
}
