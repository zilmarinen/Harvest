//
//  Rotation.swift
//  Harvest
//
//  Created by Zack Brown on 13/03/2026.
//

import Deltille
import Euclid

extension Euclid.Rotation {
    
    static func yaw(_ rotation: Deltille.Rotation) -> Self {
        
        let angle = Angle(radians: rotation.radians)
        
        return Self.yaw(angle)
    }
}
