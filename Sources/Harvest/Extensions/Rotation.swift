//
//  Rotation.swift
//  Harvest
//
//  Created by Zack Brown on 13/03/2026.
//

import Deltille
import Euclid

extension Euclid.Rotation {
    
    static func yaw(_ rotation: Triangle.Rotation) -> Self {
        
        let radians = switch rotation {
            
        case .clockwise: Triangle.Rotation.turn
        case .counterClockwise: -Triangle.Rotation.turn
        case .turns(let turns): Triangle.Rotation.turn * Double(Triangle.Rotation.wrap(turns))
        }
        
        let angle = Angle(radians: radians)
        
        return Self.yaw(angle)
    }
}
