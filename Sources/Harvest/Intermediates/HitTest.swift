//
//  HitTest.swift
//  Harvest
//
//  Created by Zack Brown on 09/11/2026.
//

import Deltille
import Euclid

public struct HitTest {
    
    public let triangle: Triangle
    public let vertex: Triangle.Vertex
    
    public init(_ vector: Vector,
                _ lattice: Double = 1.0) {
        
        let tile = Triangle(vector,
                            lattice)
        
        self.triangle = tile
        self.vertex = tile.closest(vertex: vector,
                                   .tile,
                                   lattice)
    }
}
