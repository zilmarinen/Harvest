//
//  WallTileType.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Meadow

extension WallTileType {
    
    public var description: String {
        
        switch self {
        
        case .corner: return "Corner"
        case .door: return "Door"
        case .edge: return "Edge"
        case .wall: return "Wall"
        case .window: return "Window"
        }
    }
    
    var color: Color {
        
        switch  self {
        case .corner: return Color(red: 0.73, green: 0.16, blue: 0.53, alpha: 0.7)
        case .door: return Color(red: 0.16, green: 0.73, blue: 0.53, alpha: 0.7)
        case .edge: return Color(red: 0.53, green: 0.73, blue: 0.16, alpha: 0.7)
        case .wall: return Color(red: 0.92, green: 0.24, blue: 0.24, alpha: 0.7)
        case .window: return Color(red: 0.92, green: 0.24, blue: 0.92, alpha: 0.7)
        }
    }
}
