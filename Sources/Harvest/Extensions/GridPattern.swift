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

extension GridPattern where T == Int {
    
    func apex(for ordinal: Ordinal, edgeType: SurfaceEdgeType, elevation: Int) -> TileVolume.Apex {
        
        let h0 = value(for: ordinal)
        
        let c0 = Math.quantize(value: Double(h0) * World.Constants.yScalar)
        
        switch edgeType {
        
        case .cutaway:
            
            return TileVolume.Apex(corners: Double(elevation) * World.Constants.yScalar)
        
        case .sloped:
            
            let (o0, o1) = ordinal.ordinals
            
            let c1 = Double(value(for: o1)) * World.Constants.yScalar
            let c2 = Double(value(for: ordinal.opposite)) * World.Constants.yScalar
            let c3 = Double(value(for: o0)) * World.Constants.yScalar
            
            let a1 = Math.quantize(value: max(c0, c1) - (abs(c0 - c1) / 2.0))
            let a2 = Math.quantize(value: (c0 + c1 + c2 + c3) / 4.0)
            let a3 = Math.quantize(value: max(c0, c3) - (abs(c0 - c3) / 2.0))
            
            switch ordinal {
            
            case .northWest: return TileVolume.Apex(corners: [c0, a1, a2, a3])
            case .northEast: return TileVolume.Apex(corners: [a3, c0, a1, a2])
            case .southEast: return TileVolume.Apex(corners: [a2, a3, c0, a1])
            case .southWest: return TileVolume.Apex(corners: [a1, a2, a3, c0])
            }
            
        case .terraced:
            
            return TileVolume.Apex(corners: c0)
        }
    }
}

extension GridPattern where T == Int? {
    
    func pattern(for tileType: Int) -> GridPattern<Bool> {
        
        var result = GridPattern<Bool>(value: true)
        
        for ordinal in Ordinal.allCases {
            
            guard let neighbourTileType = value(for: ordinal),
                  neighbourTileType > tileType else { continue }
                
            switch ordinal {
            
            case .northWest: result.northWest = false
            case .northEast: result.northEast = false
            case .southEast: result.southEast = false
            case .southWest: result.southWest = false
            }
        }
        
        for cardinal in Cardinal.allCases {
            
            guard let neighbourTileType = value(for: cardinal),
                  neighbourTileType > tileType else { continue }
                
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
                
            case .west:
                
                result.west = false
                result.northWest = false
                result.southWest = false
            }
        }
        
        return result
    }
    
    func edgePattern(for tileType: SurfaceTile.TileType, cardinal: Cardinal) -> GridPattern<Bool> {
        
        var result = GridPattern<Bool>(value: true)
        
        let (c0, c1) = cardinal.cardinals
        let (n0, n1) = (value(for: c0), value(for: c1))
        
        if let n0 = n0,
           n0 > tileType.primary.rawValue {
            
            result.northWest = false
            result.west = false
            result.southWest = false
        }
        
        if let n1 = n1,
           n1 > tileType.primary.rawValue {
            
            result.northEast = false
            result.east = false
            result.southEast = false
        }
        
        return result
    }
}
