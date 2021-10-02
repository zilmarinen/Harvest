//
//  Props.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import Meadow

public class Props {
    
    var buildings: [String : Footprint]
    var foliage: [String : Footprint]
    var stairs: [String : Footprint]
    
    public init() {
        
        buildings = [:]
        foliage = [:]
        stairs = [:]
    }
    
    public func footprint(prop: Prop) -> Footprint? {
     
        switch prop {
            
        case .bridge: return Footprint(coordinate: .zero)
        case .building: return buildings[prop.identifier]
        case .foliage: return foliage[prop.identifier]
        case .stairs: return stairs[prop.identifier]
        case .wall: return Footprint(coordinate: .zero)
        }
    }
    
    func cache(prop: Prop, footprint: Footprint) {
        
        switch prop {
            
        case .building: buildings[prop.identifier] = footprint
        case .foliage: foliage[prop.identifier] = footprint
        case .stairs: stairs[prop.identifier] = footprint
        default: break
        }
    }
}
