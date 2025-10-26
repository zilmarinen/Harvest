//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille

internal struct WaterTile: Codable,
                           Hashable {
    
    internal let triangle: Triangle
    
    internal let waterType: WaterType
    internal let elevation: Int
}
