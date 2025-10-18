//
//  Cursor.swift
//
//  Created by Zack Brown on 18/08/2025.
//

import Deltille
import Euclid
import RealityKit

public class Cursor: Entity {
    
    internal let cursor: ModelEntity
    
    public required init() {
        
        self.cursor = ModelEntity(mesh: .generateBox(size: 0.25),
                                  materials: [SimpleMaterial(color: .systemMint,
                                                             isMetallic: false)])
        
        super.init()
        
        name = Entity.Identifier.cursor.id
        
        addChild(cursor)
        
        components.set(CursorComponent())
    }
}

extension Cursor {
    
    public func focus(on location: Vector) {
        
        components[CursorComponent.self]?.focus = location
    }
}
