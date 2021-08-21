//
//  FoliageType.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow

extension FoliageType {
    
    var color: Color {
        
        switch  self {
        case .palm,
             .pine,
             .spruce: return Color(red: 0.09, green: 0.3, blue: 0.27, alpha: 0.7)
        }
    }
}
