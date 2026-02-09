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
    
    var cursorStyle: CursorStyle { get }
    var focus: Vector { get }
    var rotation: Double { get }
    
    func focus(on location: Vector)
    func hitTest(scale: Triangle.Scale) -> HitTest
    func rotate(direction: Triangle.Rotation)
    func toggle(style value: CursorStyle)
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
    
    internal var cursorStyle: CursorStyle {
        
        cursorComponent.cursorStyle
    }
    
    internal var focus: Vector {
        
        cursorComponent.focus
    }
    
    internal var rotation: Double {
        
        switch cursorComponent.rotation {
        
        case .clockwise: Triangle.Rotation.turn
            
        case .counterClockwise: -Triangle.Rotation.turn
        
        default: 0.0
        }
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
    
    internal func rotate(direction: Triangle.Rotation) {
        
        switch cursorComponent.rotation {
            
        case .clockwise:
            
            cursorComponent.rotation = direction == .clockwise ? .counterClockwise : nil
            
        case .counterClockwise:
            
            cursorComponent.rotation = direction == .clockwise ? nil : .clockwise
            
        default:
            
            cursorComponent.rotation = direction
        }
    }
    
    internal func toggle(style value: CursorStyle) {
        
        cursorComponent.cursorStyle = value
    }
}
