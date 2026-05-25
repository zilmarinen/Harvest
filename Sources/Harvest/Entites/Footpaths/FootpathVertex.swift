//
//  FootpathVertex.swift
//  Harvest
//
//  Created by Zack Brown on 25/04/2026.
//

import Cobble
import Lattice
import Deltille

public struct FootpathVertex: DataStoreValue {
    
    public let vertex: Triangle.Vertex
    
    public let design: Design
}
