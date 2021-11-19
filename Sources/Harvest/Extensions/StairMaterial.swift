//
//  StairMaterial.swift
//
//  Created by Zack Brown on 19/05/2021.
//

import Euclid
import Meadow

extension StairMaterial {
    
    var color: Color {
        
        switch  self {
        case .stone: return Color(0.70, 0.70, 0.70)
        }
    }
}
