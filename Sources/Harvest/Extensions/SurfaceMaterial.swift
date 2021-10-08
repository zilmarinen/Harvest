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
        
        case .dirt: return "D"
        case .sand: return "S"
        case .stone: return "S"
        case .wood: return "W"
        }
    }
    
    var color: Color {
        
        switch  self {
        case .dirt: return Color(0.35, 0.69, 0.14)
        case .sand: return .green
        case .stone: return .blue
        case .wood: return .black
        }
    }
}
