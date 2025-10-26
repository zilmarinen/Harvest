//
//  WaterType.swift
//
//  Created by Zack Brown on 26/10/2025.
//

public enum WaterType: String,
                       Codable,
                       Hashable,
                       Identifiable {
    
    case ocean
    case river
    
    public var id: String { rawValue.capitalized }
}
