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
        
        case .grass: return "G"
        case .undergrowth: return "U"
        case .water: return "W"
        }
    }
    
    public var description: String {
        
        switch self {
        
        case .grass: return "Grass"
        case .undergrowth: return "Undergrowth"
        case .water: return "Water"
        }
    }
    
    var color: Color {
        
        switch  self {
        case .grass: return Color(0.85, 0.85, 0.69)
        case .undergrowth: return Color(0.30, 0.55, 0.48)
        case .water: return Color(0.81, 0.90, 0.94)
        }
    }
}
