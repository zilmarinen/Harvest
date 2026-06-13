//
//  Biome.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Alluvium
import Euclid

public enum Biome: Int,
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
    
    public var id: String {
    
        switch self {
            
        case .boreal: "Boreal"
        case .chaparral: "Chaparral"
        case .deciduous: "Deciduous"
        case .prairie: "Prairie"
        case .rainforest: "Rainforest"
        case .scrubland: "Scrubland"
        case .tundra: "Tundra"
        }
    }
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
