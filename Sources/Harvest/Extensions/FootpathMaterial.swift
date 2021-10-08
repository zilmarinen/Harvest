//
//  FootpathMaterial.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Euclid
import Meadow

extension FootpathMaterial {
    
    var color: Color {
        
        switch self {
        
        case .cobble: return Color(0.8, 0.89, 0.45, 1.0)
        case .dirt: return Color(0.92, 0.78, 0.53, 1.0)
        case .gravel: return Color(0.8, 0.78, 0.53, 1.0)
        case .stone: return Color(0.95, 0.57, 0.2, 1.0)
        case .wood: return Color(0.54, 0.8, 0.8, 1.0)
        }
    }
}
