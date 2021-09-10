//
//  GridPattern.swift
//
//  Created by Zack Brown on 13/05/2021.
//

import Meadow

extension GridPattern where T == Tile2D? {
    
    public var count: Int { cardinalCount + ordinalCount }
    
    public var cardinalCount: Int {
        
        return (north == nil ? 0 : 1) +
                (east == nil ? 0 : 1) +
                (south == nil ? 0 : 1) +
                (west == nil ? 0 : 1)
    }
    
    public var ordinalCount: Int {
        
        return  (northEast == nil ? 0 : 1) +
                (northWest == nil ? 0 : 1) +
                (southWest == nil ? 0 : 1) +
                (southEast == nil ? 0 : 1)
    }
    
    var isParallel: Bool {
        
        return (north != nil && south != nil && east == nil && west == nil) ||
               (north == nil && south == nil && east != nil && west != nil)
    }
}

extension GridPattern where T == SurfaceMaterial? {
    
    func pattern(for material: SurfaceMaterial) -> GridPattern<Bool> {
        
        var result = GridPattern<Bool>(value: true)
        
        for ordinal in Ordinal.allCases {
            
            guard let neighbour = value(for: ordinal),
                  neighbour.rawValue > material.rawValue else { continue }
                
            switch ordinal {
            
            case .northWest: result.northWest = false
            case .northEast: result.northEast = false
            case .southEast: result.southEast = false
            default: result.southWest = false
            }
        }
        
        for cardinal in Cardinal.allCases {
            
            guard let neighbour = value(for: cardinal),
                  neighbour.rawValue > material.rawValue else { continue }
                
            switch cardinal {
            
            case .north:
                
                result.north = false
                result.northWest = false
                result.northEast = false
                
            case .east:
                
                result.east = false
                result.northEast = false
                result.southEast = false
                
            case .south:
                
                result.south = false
                result.southEast = false
                result.southWest = false
                
            default:
                
                result.west = false
                result.northWest = false
                result.southWest = false
            }
        }
        
        return result
    }
    
    func edgePattern(for material: SurfaceMaterial, cardinal: Cardinal) -> GridPattern<Bool> {
        
        var result = GridPattern<Bool>(value: true)
        
        let (c0, c1) = cardinal.cardinals
        let (n0, n1) = (value(for: c0), value(for: c1))
        
        if let n0 = n0,
           n0.rawValue > material.rawValue {
            
            result.northWest = false
            result.west = false
            result.southWest = false
        }
        
        if let n1 = n1,
           n1.rawValue > material.rawValue {
            
            result.northEast = false
            result.east = false
            result.southEast = false
        }
        
        return result
    }
}
