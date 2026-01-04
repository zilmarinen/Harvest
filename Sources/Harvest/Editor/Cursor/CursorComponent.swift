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
    internal var rotation: Triangle.Rotation? = nil
}

internal protocol HasCursorComponent: Entity {
    
    var cursorComponent: CursorComponent { get }
    
    func set(style value: CursorStyle)
    func set(focus value: Vector)
    func set(rotation value: Triangle.Rotation?)
    
    func hitTest(scale: Triangle.Scale) -> HitTest
}

extension HasCursorComponent {
    
    internal var cursorComponent: CursorComponent {
        
        get {
            
            let component = components[CursorComponent.self] ?? .init()
            
            if components[CursorComponent.self] == nil {
                
                components[CursorComponent.self] = component
            }
            
            return component
        }
        
        set  {
            
            components[CursorComponent.self] = newValue
        }
    }
    
    internal func set(style value: CursorStyle) {
        
        cursorComponent.cursorStyle = value
    }
    
    internal func set(focus value: Vector) {
        
        cursorComponent.focus = value
    }
    
    internal func set(rotation value: Triangle.Rotation?) {
        
        cursorComponent.rotation = value
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
}
