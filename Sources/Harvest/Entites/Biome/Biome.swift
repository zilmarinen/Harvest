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
    
    public var colorPalette: ColorPalette {
        
        switch self {
            
        case .boreal: .init("63424B",
                            "3A243B")
            
        case .chaparral: .init("BDA928",
                               "473F2D")
            
        case .deciduous: .init("8B7D3A",
                               "534A32")
            
        case .prairie: .init("FFA631",
                             "CB7E1F")
          
        case .rainforest: .init("6B9362",
                                "2A603B")
             
        case .scrubland: .init("F08F90",
                               "F2666C")
            
        case .tundra: .init("C2DBDF",
                            "71A2A6")
        }
    }
    
    public var foliage: ColorPalette {
        
        .init("FFC4C4",
              "EE6983",
              "C4A484",
              "B87C4C")
    }
}
