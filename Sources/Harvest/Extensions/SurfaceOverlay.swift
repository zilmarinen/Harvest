//
//  SurfaceOverlay.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Meadow

extension SurfaceOverlay {
    
    var abbreviation: String {
        
        switch self {
        
        case .grass: return "G"
        case .undergrowth: return "U"
        case .water: return "W"
        }
    }
}
