//
//  PortalType.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Meadow

extension PortalType {
    
    public var description: String {
        
        switch self {
        
        case .portal: return "Portal"
        case .spawn: return "Spawn"
        }
    }
}
