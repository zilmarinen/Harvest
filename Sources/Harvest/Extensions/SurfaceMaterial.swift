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
    
    var spriteColor: Color {
        
        switch  self {
        case .dirt: return Color(0.831, 0.705, 0.6)
        case .sand: return Color(0.952, 0.937, 0.8)
        case .stone: return Color(0.784, 0.776, 0.776)
        case .wood: return Color(0.525, 0.329, 0.223)
        }
    }
    
    var vertexColor: Color {
        
        switch  self {
        case .dirt: return .red
        case .sand: return .green
        case .stone: return .blue
        case .wood: return .black
        }
    }
}
