//
//  CursorStyle.swift
//
//  Created by Zack Brown on 19/10/2025.
//

import Deltille
import Yield

public enum CursorStyle: Equatable,
                         Identifiable,
                         Sendable {
    
    case footprint(asset: Asset)
    case hexagonal
    case triangle
    case vertex
    
    public var id: String {
        
        switch self {
            
        case .footprint: "Footprint"
        case .hexagonal: "Hexagonal"
        case .triangle: "Triangle"
        case .vertex: "Vertex"
        }
    }
}
