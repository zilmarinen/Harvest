//
//  SurfaceTileType.swift
//
//  Created by Zack Brown on 11/03/2021.
//

import Euclid
import Meadow

extension SurfaceTileType {
    
    var abbreviation: String { id.prefix(1).uppercased() }
}
