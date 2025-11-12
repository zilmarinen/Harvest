//
//  FootpathType.swift
//
//  Created by Zack Brown on 11/11/2025.
//

public enum FootpathType: String,
                          CaseIterable,
                          Codable,
                          Identifiable,
                          Sendable {
    
    case stone
    case mud
    
    public var id: String { rawValue.capitalized }
}
