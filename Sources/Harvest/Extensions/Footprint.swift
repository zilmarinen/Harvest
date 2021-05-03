//
//  Footprint.swift
//
//  Created by Zack Brown on 03/05/2021.
//

import Meadow

extension Footprint {
    
    init(coordinate: Coordinate, rotation: Cardinal = .north) {
        
        self.init(coordinate: coordinate, rotation: rotation, nodes: [.zero])
    }
}
