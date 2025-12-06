//
//  HasFootprint.swift
//
//  Created by Zack Brown on 05/12/2025.
//

import Deltille

internal protocol HasTriangleFootprint: Codable {
    
    var footprint: Triangle.Footprint { get }
}
