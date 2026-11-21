//
//  ZoomLevel.swift
//  Harvest
//
//  Created by Zack Brown on 15/11/2026.
//

public enum ZoomLevel: CaseIterable,
                       Identifiable {
    
    case x1
    case x2
    case x4
    case x8
    
    public var id: String {
        
        switch self {
            
        case .x1: "x1"
        case .x2: "x2"
        case .x4: "x4"
        case .x8: "x8"
        }
    }
    
    internal var lattice: Double {
        
        switch self {
            
        case .x1: 4
        case .x2: 8
        case .x4: 16
        case .x8: 32
        }
    }
}
