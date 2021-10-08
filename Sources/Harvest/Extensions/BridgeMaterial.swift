//
//  BridgeMaterial.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Euclid
import Meadow

extension BridgeMaterial {
    
    var color: Color {
        
        switch  self {
        case .stone: return Color(0.73, 0.53, 0.16)
        case .wood: return Color(0.16, 0.53, 0.73)
        }
    }
}
