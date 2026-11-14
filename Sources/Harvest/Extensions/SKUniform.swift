//
//  SKUniform.swift
//  Harvest
//
//  Created by Zack Brown on 14/11/2026.
//

import SpriteKit

internal extension SKUniform {
    
    enum Uniform: String,
                  Identifiable {
        
        case lattice
        
        var id: String {
            
            rawValue
        }
    }
    
    convenience init(_ uniform: Uniform,
                     value: Float) {
        
        self.init(name: uniform.id,
                  float: value)
    }
}
