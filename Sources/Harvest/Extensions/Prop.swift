//
//  Prop.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import Meadow

extension Prop {
    
    var footprint: Footprint {
        
        return Footprint(coordinate: .zero)
    }
    
    var grid: Map2D.CodingKeys {
        
        switch self {
        
        case .bridge: return .bridges
        case .building: return .buildings
        case .foliage: return .foliage
        case .stairs: return .stairs
        case .wall: return .walls
        }
    }
}
