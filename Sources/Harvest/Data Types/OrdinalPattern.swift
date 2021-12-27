//
//  OrdinalPattern.swift
//
//  Created by Zack Brown on 16/11/2021.
//

import Meadow

public struct OrdinalPattern<T: Codable & Equatable>: Codable, CustomStringConvertible, Equatable {
    
    public enum CodingKeys: String, CodingKey {
        
        case northWest = "nw"
        case northEast = "ne"
        case southEast = "se"
        case southWest = "sw"
    }
    
    public var northWest: T
    public var northEast: T
    public var southEast: T
    public var southWest: T
    
    public init(value: T) {
        
        northWest = value
        northEast = value
        southEast = value
        southWest = value
    }
    
    public init(northWest: T,
                northEast: T,
                southEast: T,
                southWest: T) {
        
        self.northWest = northWest
        self.northEast = northEast
        self.southEast = southEast
        self.southWest = southWest
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        northWest = try container.decode(T.self, forKey: .northWest)
        northEast = try container.decode(T.self, forKey: .northEast)
        southEast = try container.decode(T.self, forKey: .southEast)
        southWest = try container.decode(T.self, forKey: .southWest)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(northWest, forKey: .northWest)
        try container.encode(northEast, forKey: .northEast)
        try container.encode(southEast, forKey: .southEast)
        try container.encode(southWest, forKey: .southWest)
    }
    
    public mutating func set(value: T) {
        
        northWest = value
        northEast = value
        southEast = value
        southWest = value
    }
    
    public mutating func set(value: T, ordinal: Ordinal) {
        
        switch ordinal {
        
        case .northWest: northWest = value
        case .northEast: northEast = value
        case .southEast: southEast = value
        default: southWest = value
        }
    }
    
    public func value(for ordinal: Ordinal) -> T {
        
        switch ordinal {
        
        case .northWest: return northWest
        case .northEast: return northEast
        case .southEast: return southEast
        default: return southWest
        }
    }
    
    public var description: String { "[nw]: \(northWest)\n[ne]: \(northEast)\n[se]: \(southEast)\n[sw]: \(southWest)" }
}

extension OrdinalPattern {
    
    public func contains(value: T) -> Bool {
        
        return northWest == value || northEast == value || southEast == value || southWest == value
    }
    
    public func isHomogenous(with value: T) -> Bool {
        
        return northWest == value && northEast == value && southEast == value && southWest == value
    }
}

extension OrdinalPattern {
    
    func rotated(cardinal: Cardinal) -> Self {
        
        switch cardinal {
        case .east: return Self(northWest: northEast, northEast: southEast, southEast: southWest, southWest: northWest)
        case .south: return Self(northWest: southEast, northEast: southWest, southEast: northWest, southWest: northEast)
        case .west: return Self(northWest: southWest, northEast: northWest, southEast: northEast, southWest: southEast)
        default: return self
        }
    }
}

extension OrdinalPattern {
    
    public func isEqual(to other: Self) -> Bool {
        
        return self.rotation(matching: other) != nil
    }
    
    func rotation(matching other: Self) -> Cardinal? {
        
        for cardinal in Cardinal.allCases {
            
            if self == other.rotated(cardinal: cardinal) {
                
                return cardinal
            }
        }
        
        return nil
    }
}

extension OrdinalPattern where T == Int {
    
    var max: T { return Swift.max(northWest, northEast, southEast, southWest) }
}
