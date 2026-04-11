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
    
    func focus(on location: Vector)
    func hitTest(scale: Triangle.Scale) -> HitTest
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
}

extension HasCursorComponent {
    
    internal func focus(on location: Vector) {
        
        cursorComponent.focus = location
    }
    
    internal func hitTest(scale: Triangle.Scale) -> HitTest {
        
        let triangle = Triangle(cursorComponent.focus,
                                scale)
        
        let vertex = triangle.closest(cursorComponent.focus,
                                      scale)
        
        return .init(pointInWorld: cursorComponent.focus,
                     triangle: triangle,
                     vertex: vertex)
    }
    
    internal func rotate(_ rotation: Triangle.Rotation) {
        
        cursorComponent.rotation = .init(turns: self.rotation.turns + rotation.turns)
    }
    
    internal func toggle(style value: CursorStyle) {
        
        cursorComponent.cursorStyle = value
    }
}
