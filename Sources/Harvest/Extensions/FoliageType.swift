//
//  FoliageType.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Euclid
import Meadow

extension FoliageType {
    
    var color: Color {
        
        switch  self {
        case .bush,
             .rock,
             .tree: return Color(0.09, 0.3, 0.27, 0.7)
        }
    }
}
