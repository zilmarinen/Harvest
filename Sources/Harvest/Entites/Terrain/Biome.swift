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
    
    public var terrain: ColorPalette {
        
        switch self {
            
        case .boreal: .init(.borealPrimary,
                            .borealSecondary,
                            .borealTertiary,
                            .borealQuaternary)
            
        case .chaparral: .init(.chaparralPrimary,
                               .chaparralSecondary,
                               .chaparralTertiary,
                               .chaparralQuaternary)
            
        case .deciduous: .init(.deciduousPrimary,
                               .deciduousSecondary,
                               .deciduousTertiary,
                               .deciduousQuaternary)
            
        case .prairie: .init(.prairiePrimary,
                             .prairieSecondary,
                             .prairieTertiary,
                             .prairieQuaternary)
          
        case .rainforest: .init(.rainforestPrimary,
                                .rainforestSecondary,
                                .rainforestTertiary,
                                .rainforestQuaternary)
             
        case .scrubland: .init(.scrublandPrimary,
                               .scrublandSecondary,
                               .scrublandTertiary,
                               .scrublandQuaternary)
            
        case .tundra: .init(.tundraPrimary,
                            .tundraSecondary,
                            .tundraTertiary,
                            .tundraQuaternary)
        }
    }
}
