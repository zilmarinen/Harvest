//
//  HexagonalDataStoreTile.swift
//  Harvest
//
//  Created by Zack Brown on 13/03/2026.
//

import Deltille
import Lattice

// MARK: Terrain

extension HexagonalDataStoreTile where V == TerrainVertex {
    
    internal var apex: Int {

        let values = vertices.map {
            
            $0.value.elevation
        }

        return values.sorted(by: >).first ?? 0
    }

    internal var base: Int {

        let values = vertices.map {
            
            $0.value.elevation
        }

        return values.sorted(by: <).first ?? 0
    }
    
    internal var floor: Int {
        
        guard vertices.count == 3 else { return 0 }
        
        return base
    }
}
