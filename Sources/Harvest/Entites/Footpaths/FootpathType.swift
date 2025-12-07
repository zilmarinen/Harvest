//
//  FootpathType.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import Alluvium

public enum FootpathType: String,
                          CaseIterable,
                          Codable,
                          Identifiable,
                          Sendable {
    
    case dirt
    case stone
    
    public var id: String { rawValue.capitalized }
    
    public var colorPalette: ColorPalette {
        
        switch self {
            
        case .dirt: .init(.dirtPrimary,
                          .dirtSecondary,
                          .dirtTertiary,
                          .dirtQuaternary)

        case .stone: .init(.stonePrimary,
                           .stoneSecondary,
                           .stoneTertiary,
                           .stoneQuaternary)
        }
    }
}
