//
//  Scene.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import RealityKit

extension Scene {
    
    internal func find(entity identifier: Entity.Identifier) -> Entity? {
        
        findEntity(named: identifier.id)
    }
}
