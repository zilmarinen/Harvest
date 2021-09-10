//
//  SurfaceTileType.swift
//
//  Created by Zack Brown on 11/03/2021.
//

import Euclid
import Meadow

extension SurfaceTileType {
    
    var abbreviation: String {
        
        switch self {
        
        case .dirt: return "D"
        case .sand: return "Sa"
        case .stone: return "St"
        case .wood: return "W"
        }
    }
    
    public var description: String {
        
        switch self {
        
        case .dirt: return "Dirt"
        case .sand: return "Sand"
        case .stone: return "Stone"
        case .wood: return "Wood"
        }
    }
    
    var color: Color {
        
        switch  self {
        case .dirt: return Color(0.1, 0.5, 0.9, 1.0)
        case .sand: return Color(0.5, 0.9, 0.1, 1.0)
        case .stone: return Color(0.9, 0.1, 0.5, 1.0)
        case .wood: return Color(0.1, 0.9, 0.5, 1.0)
        }
    }
}
