//
//  Biome.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Alluvium
import Euclid

public enum Biome: String,
                   CaseIterable,
                   Codable,
                   Identifiable,
                   Sendable {
    
    case boreal
    case chaparral
    case deciduous
    case prairie
    case rainforest
    case scrubland
    case tundra
    
    public var id: String { rawValue.capitalized }
}

extension Biome {
    
    var colp: ColorPalette { .init(.borealPrimary, .borealSecondary) }
    
    public var terrain: ColorPalette {
        
        switch self {
            
        case .boreal: .init(.borealPrimary,
                            .borealSecondary,
                            .borealTertiary)
            
        case .chaparral: .init(.chaparralPrimary,
                               .chaparralSecondary,
                               .chaparralTertiary)
            
        case .deciduous: .init(.deciduousPrimary,
                               .deciduousSecondary,
                               .deciduousTertiary)
            
        case .prairie: .init(.prairiePrimary,
                             .prairieSecondary,
                             .prairieTertiary)
          
        case .rainforest: .init(.rainforestPrimary,
                                .rainforestSecondary,
                                .rainforestTertiary)
             
        case .scrubland: .init(.scrublandPrimary,
                               .scrublandSecondary,
                               .scrublandTertiary)
            
        case .tundra: .init(.tundraPrimary,
                            .tundraSecondary,
                            .tundraTertiary)
        }
    }
    
    public var foliage: ColorPalette {
        
        switch self {
            
        case .boreal: .init("FFC4C4",
                            "EE6983",
                            "C4A484",
                            "B87C4C")
            
        default: .init("91C4C3",
                       "B4DEBD",
                       "D9CFC7",
                       "C9B59C")
        }
    }
}
