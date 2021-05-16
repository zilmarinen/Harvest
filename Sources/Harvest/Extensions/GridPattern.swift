//
//  GridPattern.swift
//
//  Created by Zack Brown on 13/05/2021.
//

import Meadow

extension GridPattern where T == Int {
    
    func apex(for ordinal: Ordinal, edgeType: SurfaceEdgeType) -> TileVolume.Apex {
        
        let scalar = (1.0 / Double(World.Constants.ceiling))
        
        let h0 = value(for: ordinal)
        
        let c0 = Double(h0) * scalar
        
        switch edgeType {
        
        case .sloped:
            
            let (o0, o1) = ordinal.ordinals
            
            let c1 = Double(value(for: o1)) * scalar
            let c2 = Double(value(for: ordinal.opposite)) * scalar
            let c3 = Double(value(for: o0)) * scalar
            
            let a1 = max(c0, c1) - (abs(c0 - c1) / 2.0)
            let a2 = (c0 + c1 + c2 + c3) / 4.0
            let a3 = max(c0, c3) - (abs(c0 - c3) / 2.0)
            
            switch ordinal {
            
            case .northWest: return TileVolume.Apex(corners: [c0, a1, a2, a3])
            case .northEast: return TileVolume.Apex(corners: [a3, c0, a1, a2])
            case .southEast: return TileVolume.Apex(corners: [a2, a3, c0, a1])
            case .southWest: return TileVolume.Apex(corners: [a1, a2, a3, c0])
            }
            
        case .stairs,
             .terraced:
            
            return TileVolume.Apex(corners: c0)
        }
    }
}

extension GridPattern where T == SurfaceTile.TileType? {
    
    func pattern(for tileType: SurfaceTile.TileType) -> GridPattern<Bool> {
        
        var result = GridPattern<Bool>(value: true)
        
        for ordinal in Ordinal.allCases {
            
            guard let neighbourTileType = value(for: ordinal),
                  neighbourTileType.primary.rawValue > tileType.primary.rawValue else { continue }
                
            switch ordinal {
            
            case .northWest: result.northWest = false
            case .northEast: result.northEast = false
            case .southEast: result.southEast = false
            case .southWest: result.southWest = false
            }
        }
        
        for cardinal in Cardinal.allCases {
            
            guard let neighbourTileType = value(for: cardinal),
                  neighbourTileType.primary.rawValue > tileType.primary.rawValue else { continue }
                
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
           n0.primary.rawValue > tileType.primary.rawValue {
            
            result.northWest = false
            result.west = false
            result.southWest = false
        }
        
        if let n1 = n1,
           n1.primary.rawValue > tileType.primary.rawValue {
            
            result.northEast = false
            result.east = false
            result.southEast = false
        }
        
        return result
    }
}
