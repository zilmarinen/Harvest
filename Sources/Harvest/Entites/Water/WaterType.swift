//
//  WaterType.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Alluvium
import Euclid

public enum WaterType: String,
                       CaseIterable,
                       Codable,
                       Hashable,
                       Identifiable {
    
    case ocean
    case river
    
    public var id: String { rawValue.capitalized }
}

extension WaterType {
    
    public var colorPalette: ColorPalette {
        
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
