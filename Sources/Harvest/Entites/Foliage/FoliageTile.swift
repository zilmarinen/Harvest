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

public struct FoliageTile: HasFootprint {
    
    public let origin: Triangle
    
    public let foliageType: Triangle.Septomino
}

extension FoliageTile {
    
    public var footprint: Triangle.Footprint {
        
        .init(origin,
              [Triangle.zero])
    }
    
    public var rotation: Triangle.Rotation? { nil }
}
