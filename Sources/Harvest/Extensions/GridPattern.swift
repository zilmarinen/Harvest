//
//  GridPattern.swift
//
//  Created by Zack Brown on 13/05/2021.
//

import Meadow

extension GridPattern where T == Tile2D? {
    
    public var count: Int { cardinalCount + ordinalCount }
    
    public var cardinalCount: Int {
        
        return [north, east, south, west].compactMap { $0 }.count
    }
    
    public var ordinalCount: Int {
        
        return [northWest, northEast, southEast, southWest].compactMap { $0 }.count
    }
    
    var isParallel: Bool {
        
        return ((north != nil && east == nil) || (north == nil && east != nil) && north == south && east == west)
    }
}

extension GridPattern where T == SurfaceOverlay? {
    
    func pattern(for overlay: SurfaceOverlay) -> GridPattern<Bool> {
        
        var result = GridPattern<Bool>(value: false)
        
        for cardinal in Cardinal.allCases {
            
            guard let neighbour = value(for: cardinal),
                  neighbour.rawValue == overlay.rawValue else { continue }
                
            switch cardinal {
            
            case .north: result.north = true
            case .east: result.east = true
            case .south: result.south = true
            default: result.west = true
            }
        }
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            guard let neighbour = value(for: ordinal),
                  neighbour.rawValue == overlay.rawValue,
                  result.value(for: c0),
                  result.value(for: c1) else { continue }
                
            switch ordinal {
            
            case .northWest: result.northWest = true
            case .northEast: result.northEast = true
            case .southEast: result.southEast = true
            default: result.southWest = true
            }
        }
        
        return result
    }
}
