//
//  BridgeMaterial.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Meadow

extension BridgeMaterial {
    
    var color: Color {
        
        switch  self {
        case .stone: return Color(red: 0.73, green: 0.53, blue: 0.16, alpha: 0.7)
        }
    }
}
