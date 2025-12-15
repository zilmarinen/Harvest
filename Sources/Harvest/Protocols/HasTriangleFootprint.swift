//
//  HasTriangleFootprint.swift
//
//  Created by Zack Brown on 05/12/2025.
//

import Deltille

internal protocol HasTriangleFootprint: Codable,
                                        Hashable {
    
    var origin: Triangle { get }
    
    var footprint: Triangle.Footprint { get }
    
    var rotation: Triangle.Rotation? { get }
}
