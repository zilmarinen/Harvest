//
//  StairMaterial.swift
//
//  Created by Zack Brown on 19/05/2021.
//

import Meadow

extension StairMaterial {
    
    var color: Color {
        
        switch  self {
        case .stone: return Color(red: 0.70, green: 0.70, blue: 0.70)
        }
    }
}
