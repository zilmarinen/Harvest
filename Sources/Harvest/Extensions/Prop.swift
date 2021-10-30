//
//  Prop.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import Meadow

extension Prop {
    
    var footprint: Footprint {
        
        switch self {
        
        case .bridge: return Footprint(coordinate: .zero)
        case .building(_, let polyomino): return polyomino.footprint
        case .foliage: return Footprint(coordinate: .zero)
        case .portal: return Footprint(coordinate: .zero)
        case .stairs: return Footprint(coordinate: .zero)
        case .wall: return Footprint(coordinate: .zero)
        }
    }
    
    var grid: Map2D.CodingKeys {
        
        switch self {
        
        case .bridge: return .bridges
        case .building: return .buildings
        case .foliage: return .foliage
        case .portal: return .portals
        case .stairs: return .stairs
        case .wall: return .walls
        }
    }
}
