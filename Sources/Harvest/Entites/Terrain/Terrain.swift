//
//  Terrain.swift
//
//  Created by Zack Brown on 10/08/2025.
//

import Deltille
import Lattice
import RealityKit

internal class Terrain: HexagonalLattice<TerrainChunk, TerrainVertex> {
    
    internal enum Constant {
        
        static let apexHeight = 0.1
        static let baseHeight = 0.5
    }
    
    internal static func apex(for elevation: Int) -> Double {
        
        base(for: elevation) + Constant.apexHeight
    }
    
    internal static func base(for elevation: Int) -> Double {
        
        Constant.baseHeight * Double(elevation)
    }
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.terrain.id
    }
}
