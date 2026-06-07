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
        
        zoom = Self.maximumZoom
        
        camera.near = Self.near
        camera.far = Self.far
        camera.scale = zoom
        camera.scaleDirection = .vertical
        
        components.set(camera)
    }
}

extension float4x4 {
    
    static func ortho(left: Float,
                      right: Float,
                      top: Float,
                      bottom: Float,
                      near: Float,
                      far: Float) -> Self {
        
        let rml = right - left
        let tmb = top - bottom
        let fmn = far - near
        
        return float4x4(columns: (SIMD4<Float>(2.0 / rml, 0.0, 0.0, 0.0),
                                  SIMD4<Float>(0.0, 2.0 / tmb, 0.0, 0.0),
                                  SIMD4<Float>(0.0, 0.0, -2.0 / fmn, 0.0),
                                  SIMD4<Float>(-(right + left) / rml,
                                                -(top + bottom) / tmb,
                                                -(far + near) / fmn,
                                                1.0)))
    }
}
