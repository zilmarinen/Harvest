//
//  FoliageVertex.swift
//  Harvest
//
//  Created by Zack Brown on 10/03/2026.
//

import Bivouac
import Deltille
import Lattice
import Verdure

public struct FoliageVertex: DataStoreValue {
    
    public let vertex: Triangle.Vertex
    
    public let foliageType: Triangle.Septomino
}
