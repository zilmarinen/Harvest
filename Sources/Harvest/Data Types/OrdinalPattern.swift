//
//  OrdinalPattern.swift
//
//  Created by Zack Brown on 16/11/2021.
//

import Meadow

public struct OrdinalPattern<T: Codable & Hashable>: Codable, Hashable {
    
    public enum CodingKeys: String, CodingKey {
        
        case northWest = "nw"
        case northEast = "ne"
        case southEast = "se"
        case southWest = "sw"
    }
    
    var values: [T] { [northWest, northEast, southEast, southWest] }
    var uniqueValues: [T] { Array(Set(values)) }
    
    private(set) public var northWest: T
    private(set) public var northEast: T
    private(set) public var southEast: T
    private(set) public var southWest: T
    
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
}

extension OrdinalPattern {
    
    func rotated(ordinal: Ordinal) -> Self {
        
        switch ordinal {
        case .northEast: return Self(northWest: northEast, northEast: southEast, southEast: southWest, southWest: northWest)
        case .southEast: return Self(northWest: southEast, northEast: southWest, southEast: northWest, southWest: northEast)
        case .southWest: return Self(northWest: southWest, northEast: northWest, southEast: northEast, southWest: southEast)
        default: return self
        }
    }
}

extension OrdinalPattern where T == SurfaceSocket {
    
    public var area: Int {
        
        var result = 0
        
        for ordinal in Ordinal.allCases {
            
            let socket = value(for: ordinal)
            
            result += (socket.inner ? 1 : 0) + (socket.outer ? 1 : 0)
        }
        
        return result
    }
    
    public var bitmask: Int {
        
        var result = 0
        
        for index in Ordinal.allCases.indices {
            
            let ordinal = Ordinal.allCases[index]
            
            if value(for: ordinal).outer {
            
                result += 1 << index
            }
        }
        
        return result
    }
    
    func has(vacancy: Self) -> Bool {
        
        for ordinal in Ordinal.allCases {
            
            let lhs = vacancy.value(for: ordinal)
            
            guard lhs.inner || lhs.outer else { continue }
            
            let rhs = value(for: ordinal)
            
            if (lhs.inner && !rhs.inner) || (lhs.outer && !rhs.outer) { return false }
        }
        
        return true
    }
    
    mutating func subtract(sockets: Self) {
        
        for ordinal in Ordinal.allCases {
            
            let lhs = sockets.value(for: ordinal)
            let rhs = value(for: ordinal)
            
            set(value: SurfaceSocket(inner: lhs.inner ? false : rhs.inner, outer: lhs.outer ? false : rhs.outer), ordinal: ordinal)
        }
    }
}
