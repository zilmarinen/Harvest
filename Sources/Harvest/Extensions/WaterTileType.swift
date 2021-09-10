//
//  WaterTileType.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Euclid
import Meadow

extension WaterTileType {
    
    public var description: String {
        
        switch self {
        
        case .water: return "Water"
        }
    }
    
    var color: Color {
        
        switch self {
        
        case .water: return Color(0.73, 0.94, 0.98, 0.7)
        }
    }
}
