//
//  StaircaseTile.swift
//
//  Created by Zack Brown on 05/12/2025.
//

import Deltille
import Lattice
import Newel

public struct StaircaseTile: TriangularDataStoreTile {
    
    public let origin: Triangle.Vertex
    
    public var rotation: Rotation?
    
    public let staircaseType: StaircaseType
}

extension StaircaseTile {
    
    public var footprint: Triangle.Footprint {
        
        .init(.init(origin),
              [Coordinate.zero])
    }
}
