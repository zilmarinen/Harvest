//
//  SurfaceSockets.swift
//
//  Created by Zack Brown on 16/11/2021.
//

import Meadow

public struct SurfaceSockets: Codable, CustomStringConvertible, Equatable {
    
    public var upper: OrdinalPattern<SurfaceMaterial>
    public var lower: OrdinalPattern<SurfaceMaterial>
    
    public init(value: SurfaceMaterial) {
        
        self.upper = OrdinalPattern(value: value)
        self.lower = OrdinalPattern(value: value)
    }
    
    public init(upper: OrdinalPattern<SurfaceMaterial>, lower: OrdinalPattern<SurfaceMaterial>) {
        
        self.upper = upper
        self.lower = lower
        
    }
    
    public mutating func set(value: SurfaceMaterial) {
        
        upper.set(value: value)
        lower.set(value: value)
    }
    
    public mutating func set(value: SurfaceMaterial, ordinal: Ordinal) {
        
        upper.set(value: value, ordinal: ordinal)
        lower.set(value: value, ordinal: ordinal)
    }
    
    public func isEqual(to other: Self) -> Bool { upper.isEqual(to: other.upper) && lower.isEqual(to: other.lower) }
    
    public func contains(value: SurfaceMaterial) -> Bool { upper.contains(value: value) || lower.contains(value: value) }
    
    public func isHomogenous(with value: SurfaceMaterial) -> Bool { upper.isHomogenous(with: value) && lower.isHomogenous(with: value) }
    
    public func merge(sockets: Self) -> Self {
        
        var l = lower
        var u = upper
        
        for ordinal in Ordinal.allCases {
         
            let llhs = l.value(for: ordinal)
            let ulhs = u.value(for: ordinal)
            
            let lrhs = sockets.lower.value(for: ordinal)
            let urhs = sockets.upper.value(for: ordinal)
            
            l.set(value: llhs.max(other: lrhs), ordinal: ordinal)
            u.set(value: ulhs.max(other: urhs), ordinal: ordinal)
        }
        
        return Self(upper: u, lower: l)
    }
    
    public var description: String { "[upper]:\n\(upper.description)\n[lower]:\n\(lower.description)" }
}

extension SurfaceSockets {
    
    func rotated(cardinal: Cardinal) -> Self {
        
        return Self(upper: upper.rotated(cardinal: cardinal), lower: lower.rotated(cardinal: cardinal))
    }
}

extension SurfaceSockets {
    
    func rotation(matching other: Self) -> Cardinal? {
     
        for cardinal in Cardinal.allCases {
            
            if self == other.rotated(cardinal: cardinal) {
                
                return cardinal
            }
        }
        
        return nil
    }
}

extension SurfaceSockets {
    
    public var bitmask: Int {
        
        var result = 0
        
        for ordinal in Ordinal.allCases {
            
            result += lower.value(for: ordinal).bitmask
            result += upper.value(for: ordinal).bitmask
        }
        
        return result
    }
}
