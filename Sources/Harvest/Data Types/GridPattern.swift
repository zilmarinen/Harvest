//
//  GridPattern.swift
//
//  Created by Zack Brown on 16/11/2021.
//

import Meadow

public struct GridPattern<T: Codable & Hashable>: Codable, Hashable {
    
    public enum CodingKeys: String, CodingKey {
        
        case cardinals = "c"
        case ordinals = "o"
    }
    
    public var cardinals: CardinalPattern<T>
    public var ordinals: OrdinalPattern<T>
    
    public init(value: T) {
        
        cardinals = CardinalPattern(value: value)
        ordinals = OrdinalPattern(value: value)
    }
    
    public init(north: T,
                east: T,
                south: T,
                west: T,
                northWest: T,
                northEast: T,
                southEast: T,
                southWest: T) {
        
        cardinals = CardinalPattern(north: north, east: east, south: south, west: west)
        ordinals = OrdinalPattern(northWest: northWest, northEast: northEast, southEast: southEast, southWest: southWest)
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cardinals = try container.decode(CardinalPattern<T>.self, forKey: .cardinals)
        ordinals = try container.decode(OrdinalPattern<T>.self, forKey: .ordinals)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cardinals, forKey: .cardinals)
        try container.encode(ordinals, forKey: .ordinals)
    }
    
    public mutating func set(value: T) {
        
        cardinals.set(value: value)
        ordinals.set(value: value)
    }
    
    public mutating func set(value: T, cardinal: Cardinal) {
        
        cardinals.set(value: value, cardinal: cardinal)
    }
    
    public mutating func set(value: T, ordinal: Ordinal) {
        
        ordinals.set(value: value, ordinal: ordinal)
    }
    
    public func value(for cardinal: Cardinal) -> T { cardinals.value(for: cardinal) }
    
    public func value(for ordinal: Ordinal) -> T { ordinals.value(for: ordinal) }
}
