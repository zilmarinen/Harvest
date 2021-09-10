//
//  FootpathTileType.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Euclid
import Meadow

extension FootpathTileType {
    
    public var description: String {
        
        switch self {
        
        case .cobble: return "Cobble"
        case .dirt: return "Dirt"
        case .gravel: return "Gravel"
        case .stone: return "Stone"
        case .wood: return "Wood"
        }
    }
    
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
