//
//  FenceVertex.swift
//  Harvest
//
//  Created by Zack Brown on 03/05/2026.
//

import Deltille
import Lattice
import Palisade

public struct FenceVertex: DataStoreValue {
    
    public let coord: Coordinate
    
    public let rampart: Rampart
    public let segment: FenceSegment
}
