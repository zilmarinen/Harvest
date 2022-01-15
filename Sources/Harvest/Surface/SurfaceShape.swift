//
//  SurfaceShape.swift
//
//  Created by Zack Brown on 21/11/2021.
//

public enum SurfaceShape: String, CaseIterable, Codable, Equatable, Identifiable {
    
    case concave
    case convex
    case straight
    
    public var id: String { rawValue }
    
    public var opposite: SurfaceShape {
        
        switch self {
            
        case .concave: return .convex
        case .convex: return .concave
        case .straight: return .straight
        }
    }
}
