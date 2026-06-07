//
//  HasOrthographicCamera.swift
//  Harvest
//
//  Created by Zack Brown on 05/06/2026.
//

import Deltille
import Euclid
import RealityKit

internal protocol HasOrthographicCamera: HasTransform {
    
    var camera: OrthographicCameraComponent { get set }
    
    var focus: Vector { get set }
    var rotation: Hexagon.Rotation { get set }
    var zoom: Float { get set }
    
    func focus(on value: Vector)
    func translate(by value: Vector)
    func rotate(_ value: Hexagon.Rotation)
    func zoom(delta value: Double)
}

internal extension HasOrthographicCamera {
    
    static var maximumZoom: Float { 100.0 }
    static var minimumZoom: Float { 5.0 }
    
    static var near: Float { -10.0 }
    static var far: Float { 1000.0 }
}

internal extension HasOrthographicCamera {
    
    internal func focus(on value: Vector) {
        
        focus = value
    }
    
    internal func rotate(_ value: Hexagon.Rotation) {
        
        rotation = .init(turns: rotation.turns + value.turns)
    }
    
    internal func translate(by value: Vector) {
        
        //zero out y component to translate along xz plane
        let forward = Vector(forward.x,
                             0.0,
                             forward.z).normalized()
        
        //scale translation based on zoom level
        let scalar = Double((1.0 / (Self.maximumZoom - Self.minimumZoom)) * zoom)
        
        focus += (forward * (-value.z * scalar)) + (right * (-value.x * scalar))
    }
    
    internal func zoom(delta value: Double) {
        
        zoom = max(Self.minimumZoom,
                   min(Self.maximumZoom,
                       zoom + Float(value)))
        
        camera.scale = zoom
        
        //TODO: Investigate why we need to re-apply the camera component after updating the scale property
        components.set(camera)
    }
}
