//
//  FenceSegment.swift
//  Harvest
//
//  Created by Zack Brown on 03/05/2026.
//

public enum FenceSegment: String,
                          CaseIterable,
                          Codable,
                          Identifiable,
                          Sendable {
    
    case doorway
    case fence
    
    public var id: String { rawValue.capitalized }
}
