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
        case foliage
        case footpaths
        case staircases
        case terrain
        case water
        
        internal var id: String { rawValue.capitalized }
    }
}
