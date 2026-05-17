//
//  Cursor.swift
//
//  Created by Zack Brown on 18/08/2025.
//

import Deltille
import Euclid
import RealityKit

internal class Cursor: Entity,
                       HasCursorComponent {
    
    internal let blueprint = BlueprintCursor()
    internal let triangular = TriangularCursor()
    internal let hexagonal = VertexCursor()
    
    public required init() {
        
        super.init()
        
        name = Entity.Identifier.cursor.id
        
        components.set(CursorComponent())
        
        addChild(blueprint)
        addChild(hexagonal)
        addChild(triangular)
        
        toggle(style: cursorStyle)
    }
}

extension Cursor {
    
    internal func toggle(style value: CursorStyle) {
        
        cursorComponent.cursorStyle = value
        
        switch value {
            
        case .footprint(let asset):
            
            blueprint.isEnabled = true
            hexagonal.isEnabled = false
            triangular.isEnabled = false
            
            blueprint.set(asset: asset)
            
        case .triangle:
            
            blueprint.isEnabled = false
            hexagonal.isEnabled = false
            triangular.isEnabled = true
            
        case .hexagonal,
             .vertex:
            
            blueprint.isEnabled = false
            hexagonal.isEnabled = true
            triangular.isEnabled = false
            
            hexagonal.set(mode: value == .hexagonal ? .hexagon : .vertex)
        }
    }
}
