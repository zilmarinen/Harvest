//
//  Entity.swift
//  Harvest
//
//  Created by Zack Brown on 24/01/2026.
//

import Euclid
import RealityKit

extension Entity {
    
    internal var forward: Vector {
        
        transform.matrix.forward
    }
    
    internal var right: Vector {
        
        transform.matrix.right
    }
}
