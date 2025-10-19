//
//  CursorStyle.swift
//
//  Created by Zack Brown on 19/10/2025.
//

public enum CursorStyle: String,
                         CaseIterable,
                         Identifiable,
                         Sendable {
    
    case hexagonal
    case triangle
    case vertex
    
    public var id: String { rawValue.capitalized }
}
