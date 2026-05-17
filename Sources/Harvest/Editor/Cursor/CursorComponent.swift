//
//  CursorComponent.swift
//
//  Created by Zack Brown on 18/08/2025.
//

import Deltille
import Euclid
import RealityKit

internal struct CursorComponent: Component {
    
    internal var cursorStyle: CursorStyle = .vertex
    internal var focus = Vector.zero
    internal var rotation: Triangle.Rotation = .identity
}

internal protocol HasCursorComponent: Entity {
    
    var cursorComponent: CursorComponent { get }
    
    var cursorStyle: CursorStyle { get }
    var focus: Vector { get }
    var rotation: Triangle.Rotation { get }
    
    var triangle: Triangle { get }
    var vertex: Triangle.Vertex { get }
    
    func focus(on location: Vector)
    func rotate(_ rotation: Triangle.Rotation)
    func toggle(style value: CursorStyle)
}

extension HasCursorComponent {
    
    internal var cursorComponent: CursorComponent {
        
        get {
            
            let component = components[CursorComponent.self] ?? .init()
            
            if components[CursorComponent.self] == nil {
                
                components.set(component)
            }
            
            return component
        }
        
        set  {
            
            components.set(newValue)
        }
    }
    
    internal var cursorStyle: CursorStyle {
        
        cursorComponent.cursorStyle
    }
    
    internal var focus: Vector {
        
        cursorComponent.focus
    }
    
    internal var rotation: Triangle.Rotation {
        
        cursorComponent.rotation
    }
    
    internal var triangle: Triangle {
        
        .init(.init(focus.x,
                    0.0,
                    focus.z),
              .tile)
    }
    
    internal var vertex: Triangle.Vertex {
        
        triangle.closest(focus,
                         .tile)
    }
}

extension HasCursorComponent {
    
    internal func focus(on location: Vector) {
        
        cursorComponent.focus = location
    }
    
    internal func rotate(_ rotation: Triangle.Rotation) {
        
        cursorComponent.rotation = .init(turns: self.rotation.turns + rotation.turns)
    }
}
