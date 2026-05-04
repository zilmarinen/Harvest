//
//  FenceVertex.swift
//  Harvest
//
//  Created by Zack Brown on 03/05/2026.
//

import Deltille
import Palisade

public struct FenceVertex: Codable,
                           Hashable {
    
    public let vertex: Triangle.Vertex
    
    public let rampart: Rampart
    public let segment: FenceSegment
}
