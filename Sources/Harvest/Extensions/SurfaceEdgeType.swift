//
//  SurfaceEdgeType.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Meadow

extension SurfaceEdgeType {
    
    var abbreviation: String {
        
        switch self {
        
        case .cutaway: return "C"
        case .sloped: return "S"
        case .terraced: return "T"
        }
    }
    
    public var description: String {
        
        switch self {
        
        case .cutaway: return "Cutaway"
        case .sloped: return "Sloped"
        case .terraced: return "Terraced"
        }
    }
}
