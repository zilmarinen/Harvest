//
//  Cursor.swift
//
//  Created by Zack Brown on 18/08/2025.
//

import Deltille
import Euclid
import RealityKit

public class Cursor: Entity,
                     HasCursorComponent {
    
    internal let vertex = Mesh.cursor(.conway)
    
    public required init() {
        
        super.init()
        
        name = Entity.Identifier.cursor.id
        
        let mesh = Mesh.cursor(.conway)
        
        for _ in 0..<7 {
            
            guard let model = try? ModelEntity(mesh) else { continue }
            
            addChild(model)
        }
        
        components.set(CursorComponent())
    }
}
