//
//  SurfaceStyle.swift
//
//  Created by Zack Brown on 21/11/2021.
//

public enum SurfaceStyle: String, CaseIterable, Codable, Equatable, Identifiable {
    
    case concave
    case convex
    case straight
    
    public var id: String { rawValue }
}
