//
//  TerrainType.swift
//  Harvest
//
//  Created by Zack Brown on 24/09/2025.
//

import Euclid

public enum TerrainType: String,
                         CaseIterable,
                         Codable,
                         Identifiable {
    
    case boreal
    case chaparral
    case deciduous
    case prairie
    case rainforest
    case scrubland
    case tundra
    
    public var id: String { rawValue.capitalized }
}
//
//extension TerrainType {
//    
//    public var colorPalette: ColorPalette {
//        
//        switch self {
//            
//        case .boreal: return .init("63424B",
//                                   "3A243B")
//            
//        case .chaparral: return .init("BDA928",
//                                      "473F2D")
//            
//        case .deciduous: return .init("8B7D3A",
//                                      "534A32")
//            
//        case .prairie: return .init("FFA631",
//                                    "CB7E1F")
//          
//        case .rainforest: return .init("6B9362",
//                                       "2A603B")
//             
//        case .scrubland: return .init("F08F90",
//                                      "F2666C")
//            
//        case .tundra: return .init("C2DBDF",
//                                   "71A2A6")
//        }
//    }
//}

extension TerrainType {
    
    public var apexColor: Color {
        
        switch self {
            
        case .boreal: .init(0.388, 0.259, 0.294)
            
        case .chaparral: .init(0.741, 0.663, 0.157)
            
        case .deciduous: .init(0.0, 0.0, 0.0)
            
        case .prairie: .init(0.0, 0.0, 0.0)
          
        case .rainforest: .init(0.0, 0.0, 0.0)
             
        case .scrubland: .init(0.0, 0.0, 0.0)
            
        case .tundra: .init(0.0, 0.0, 0.0)
        }
    }
    
    public var baseColor: Color {
        
        switch self {
            
        case .boreal: .init(0.227, 0.141, 0.231)
            
        case .chaparral: .init(0.278, 0.247, 0.176)
            
        case .deciduous: .init(0.0, 0.0, 0.0)
            
        case .prairie: .init(0.0, 0.0, 0.0)
          
        case .rainforest: .init(0.0, 0.0, 0.0)
             
        case .scrubland: .init(0.0, 0.0, 0.0)
            
        case .tundra: .init(0.0, 0.0, 0.0)
        }
    }
}
