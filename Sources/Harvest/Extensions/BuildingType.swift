//
//  BuildingType.swift
//  Orchard
//
//  Created by Zack Brown on 09/04/2021.
//

import Meadow

extension BuildingType {
    
    public var description: String {
        
        switch self {
        
        case .house: return "House"
        case .home: return "Home"
        }
    }
    
    var color: Color {
        
        switch  self {
        case .house: return Color(red: 0.73, green: 0.53, blue: 0.16, alpha: 0.7)
        case .home: return Color(red: 0.43, green: 0.83, blue: 0.16, alpha: 0.7)
        }
    }
}
