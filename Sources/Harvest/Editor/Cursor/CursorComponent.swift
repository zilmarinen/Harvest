//
//  CursorComponent.swift
//
//  Created by Zack Brown on 18/08/2025.
//

import Euclid
import RealityKit

internal struct CursorComponent: Component {
    
    internal var cursorStyle: CursorStyle = .vertex
    internal var focus = Vector.zero
}

internal protocol HasCursorComponent: Entity {
    
    var cursorComponent: CursorComponent { get }
    
    func set(cursorStyle value: CursorStyle)
    func set(focus value: Vector)
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
    
    internal func set(cursorStyle value: CursorStyle) {
        
        cursorComponent.cursorStyle = value
    }
    
    internal func set(focus value: Vector) {
        
        cursorComponent.focus = value
    }
}
