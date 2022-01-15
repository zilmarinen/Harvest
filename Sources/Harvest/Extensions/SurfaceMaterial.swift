//
//  SurfaceMaterial.swift
//
//  Created by Zack Brown on 07/09/2021.
//

import Euclid
import Meadow

extension SurfaceMaterial {
    
    var abbreviation: String {
        
        switch self {
        
        case .air: return "A"
        case .dirt: return "D"
        case .sand: return "Sa"
        case .stone: return "St"
        case .undergrowth: return "U"
        }
    }
    
    var spriteColor: Color {
        
        switch  self {
        case .air: return .clear
        case .dirt: return Color(0.831, 0.705, 0.6)
        case .sand: return Color(0.952, 0.937, 0.8)
        case .stone: return Color(0.784, 0.776, 0.776)
        case .undergrowth: return Color(0.525, 0.329, 0.223)
        }
    }
    
    func max(material: SurfaceMaterial) -> SurfaceMaterial { rawValue > material.rawValue ? self : material }
}
