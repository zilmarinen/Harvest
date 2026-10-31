//
//  Fluid.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Alluvium

public enum Fluid: Int, CaseIterable, Codable, Identifiable, Sendable {
    
    case ocean
    case river
    
    public var id: String {
        
        switch self {
            
        case .ocean: "Ocean"
        case .river: "River"
        }
    }
}

internal extension Fluid {
    
    var water: ColorPalette {
        
        switch self {
            
        case .ocean: .init(.oceanPrimary,
                           .oceanSecondary,
                           .oceanTertiary,
                           .oceanQuaternary)
            
        case .river: .init(.riverPrimary,
                           .riverSecondary,
                           .riverTertiary,
                           .riverQuaternary)
        }
    }
}
