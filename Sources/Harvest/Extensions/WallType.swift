//
//  WallType.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Euclid
import Meadow

extension WallType {
    
    var color: Color {
        
        switch  self {
        case .corner: return Color(0.73, 0.16, 0.53, 0.7)
        case .door: return Color(0.16, 0.73, 0.53, 0.7)
        case .edge: return Color(0.53, 0.73, 0.16, 0.7)
        case .wall: return Color(0.92, 0.24, 0.24, 0.7)
        case .window: return Color(0.92, 0.24, 0.92, 0.7)
        }
    }
}
