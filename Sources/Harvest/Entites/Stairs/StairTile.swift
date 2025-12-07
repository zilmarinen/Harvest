//
//  StairTile.swift
//
//  Created by Zack Brown on 05/12/2025.
//

import Deltille
import Newel

internal struct StairTile: HasTriangleFootprint {
    
    internal var footprint: Triangle.Footprint { stoop.footprint }
    
    internal let stoop: Stoop
}

