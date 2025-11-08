//
//  WaterType.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Alluvium
import Euclid

public enum WaterType: String,
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
            
        case .ocean: .init("CBDCEB",
                           "6D94C5")
            
        case .river: .init("48B3AF",
                           "A7E399")
        }
    }
}
