//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille

public struct WaterTile: Codable,
                           Hashable {
    
    public let triangle: Triangle
    
    public let waterType: WaterType
    public let elevation: Int
}
