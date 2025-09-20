//
//  HeightMapSlice.swift
//  Harvest
//
//  Created by Zack Brown on 16/09/2025.
//

import Deltille

internal struct HeightMapSlice {
    
    internal let sieve: Sieve<Triangle.Scale,
                              Triangle,
                              Triangle.Vertex>
    
    internal let vertices: [Triangle.Vertex : HeightMapVertex]
}

