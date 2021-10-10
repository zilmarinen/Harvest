//
//  SurfaceOverlay.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Euclid
import Meadow

extension SurfaceOverlay {
    
    var abbreviation: String {
        
        switch self {
        
        case .grass: return "G"
        case .undergrowth: return "U"
        case .water: return "W"
        }
    }
    
    var spriteColor: Color {
        
        switch  self {
        case .grass: return Color(0.223, 0.639, 0.533)
        case .undergrowth: return Color(0.372, 0.478, 0.38)
        case .water: return Color(0.843, 0.913, 0.968)
        }
    }
}
