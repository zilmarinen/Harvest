//
//  Entity+Identifier.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import RealityKit

extension Entity {
    
    internal enum Identifier: String,
                              Identifiable,
                              Sendable {
        
        case buildings
        case camera
        case cursor
        case fences
        case foliage
        case footpaths
        case portals
        case slopes
        case terrain
        case water
        
        internal var id: String { rawValue.capitalized }
    }
}

extension AnchorEntity {
    
    internal enum Identifier: String,
                              Hashable,
                              Identifiable,
                              Sendable {
        
        case world
        
        internal var id: String { rawValue.capitalized }
    }
    
    internal func find(entity identifier: Entity.Identifier) -> Entity? {
        
        findEntity(named: identifier.id)
    }
}
