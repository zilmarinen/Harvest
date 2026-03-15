//
//  FoliageTile.swift
//  Harvest
//
//  Created by Zack Brown on 10/03/2026.
//

import Bivouac
import Deltille
import Lattice
import Verdure

public struct FoliageTile: TriangularDataStoreTile {
    
    public let origin: Triangle.Vertex
    
    public let foliageType: Triangle.Septomino
}

extension FoliageTile {
    
    public var footprint: Triangle.Footprint {
        
        .init(.init(origin),
              [Coordinate.zero])
    }
    
    public var rotation: Triangle.Rotation? { nil }
}
