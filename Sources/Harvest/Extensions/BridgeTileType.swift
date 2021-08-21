//
//  BridgeTileType.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Meadow

extension BridgeTileType {
    
    var abbreviation: String {
        
        switch self {
            
        case .corner: return "c"
        case .edge: return "e"
        case .path: return "p"
        case .wall: return "w"
        }
    }
}
