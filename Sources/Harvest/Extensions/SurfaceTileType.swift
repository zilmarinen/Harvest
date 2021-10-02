//
//  SurfaceTileType.swift
//
//  Created by Zack Brown on 11/03/2021.
//

import Euclid
import Meadow

extension SurfaceTileType {
    
    var abbreviation: String {
        
        switch self {
        
        case .sloped: return "S"
        case .terraced: return "T"
        }
    }
    
    public var description: String {
        
        switch self {
        
        case .sloped: return "Sloped"
        case .terraced: return "Terraced"
        }
    }
}
