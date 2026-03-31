//
//  CameraComponent.swift
//  Harvest
//
//  Created by Zack Brown on 22/01/2026.
//

import Deltille
import Euclid
import RealityKit

internal struct CameraComponent: Component {
    
    internal static let maximumRadius = 100.0
    internal static let minimumRadius = 10.0
    
    internal var focus: Vector = .zero
    internal var radius: Double = Self.maximumRadius
    internal var rotation: Deltille.Rotation = .identity
}

internal protocol HasCameraComponent: Entity {
    
    var cameraComponent: CameraComponent { get }
    
    var pov: PerspectiveCamera { get }
    
    var focus: Vector { get }
    var radius: Double { get }
    var rotation: Deltille.Rotation { get }
    
    func focus(on location: Vector)
    func translate(by delta: Vector)
    func rotate(_ rotation: Deltille.Rotation)
    func zoom(delta: Double)
}

extension HasCameraComponent {
    
    internal var cameraComponent: CameraComponent {
        
        get {
            
            let component = components[CameraComponent.self] ?? .init()
            
            if components[CameraComponent.self] == nil {
                
                components.set(component)
            }
            
            return component
        }
        
        set  {
            
            components.set(newValue)
        }
    }
    
    internal var focus: Vector {
        
        cameraComponent.focus
    }
    
    internal var radius: Double {
        
        cameraComponent.radius
    }
    
    internal var rotation: Deltille.Rotation {
        
        cameraComponent.rotation
    }
}

extension HasCameraComponent {
    
    internal func focus(on location: Vector) {
        
        cameraComponent.focus = location
    }
    
    internal func rotate(_ rotation: Deltille.Rotation) {
        
        cameraComponent.rotation = .init(turns: self.rotation.turns + rotation.turns)
    }
    
    internal func translate(by delta: Vector) {
        
        //zero out y component to translate along xz plane
        let forward = Vector(pov.forward.x,
                             0.0,
                             pov.forward.z).normalized()
        
        //scale translation based on zoom level
        let scalar = (1.0 / (CameraComponent.maximumRadius - CameraComponent.minimumRadius)) * cameraComponent.radius
        
        cameraComponent.focus += (forward * (-delta.z * scalar)) + (pov.right * (-delta.x * scalar))
    }
    
    internal func zoom(delta: Double) {
        
        cameraComponent.radius = max(CameraComponent.minimumRadius,
                                     min(CameraComponent.maximumRadius,
                                         cameraComponent.radius + delta))
    }
}
