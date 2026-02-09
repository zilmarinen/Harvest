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
    internal var rotation: Triangle.Rotation? = nil
}

internal protocol HasCameraComponent: Entity {
    
    var cameraComponent: CameraComponent { get }
    
    var pov: PerspectiveCamera { get }
    
    var focus: Vector { get }
    var radius: Double { get }
    var rotation: Double { get }
    
    func focus(on location: Vector)
    func rotate(direction: Triangle.Rotation)
    func translate(by delta: Vector)
    func zoom(delta: Double)
}

extension HasCameraComponent {
    
    internal var cameraComponent: CameraComponent {
        
        get {
            
            let component = components[CameraComponent.self] ?? .init()
            
            if components[CameraComponent.self] == nil {
                
                components[CameraComponent.self] = component
            }
            
            return component
        }
        
        set  {
            
            components[CameraComponent.self] = newValue
        }
    }
    
    internal var focus: Vector {
        
        cameraComponent.focus
    }
    
    internal var radius: Double {
        
        cameraComponent.radius
    }
    
    internal var rotation: Double {
        
        switch cameraComponent.rotation {
        
        case .clockwise: Triangle.Rotation.turn
            
        case .counterClockwise: -Triangle.Rotation.turn
        
        default: 0.0
        }
    }
}

extension HasCameraComponent {
    
    internal func focus(on location: Vector) {
        
        cameraComponent.focus = location
    }
    
    internal func rotate(direction: Triangle.Rotation) {
        
        switch cameraComponent.rotation {
            
        case .clockwise:
            
            cameraComponent.rotation = direction == .clockwise ? .counterClockwise : nil
            
        case .counterClockwise:
            
            cameraComponent.rotation = direction == .clockwise ? nil : .clockwise
            
        default:
            
            cameraComponent.rotation = direction
        }
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
