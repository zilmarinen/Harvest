//
//  CursorMode.swift
//  Harvest
//
//  Created by Zack Brown on 12/11/2026.
//

import AppKit

internal enum CursorMode: Identifiable {
    
    case tile
    case vertex
    
    internal var id: String {
        
        switch self {
            
        case .tile: "T"
        case .vertex: "V"
        }
    }
    
    internal var color: NSColor {
        
        switch self {
            
        case .tile: .systemPink
        case .vertex: .systemPurple
        }
    }
}
