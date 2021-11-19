//
//  CardinalPattern.swift
//
//  Created by Zack Brown on 16/11/2021.
//

import Meadow

public struct CardinalPattern<T: Codable & Equatable>: Codable, Equatable {
    
    public enum CodingKeys: String, CodingKey {
        
        case north = "n"
        case east = "e"
        case south = "s"
        case west = "w"
    }
    
    public var north: T
    public var east: T
    public var south: T
    public var west: T
    
    public init(value: T) {
        
        north = value
        east = value
        south = value
        west = value
    }
    
    public init(north: T,
                east: T,
                south: T,
                west: T) {
        
        self.north = north
        self.east = east
        self.south = south
        self.west = west
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        north = try container.decode(T.self, forKey: .north)
        east = try container.decode(T.self, forKey: .east)
        south = try container.decode(T.self, forKey: .south)
        west = try container.decode(T.self, forKey: .west)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(north, forKey: .north)
        try container.encode(east, forKey: .east)
        try container.encode(south, forKey: .south)
        try container.encode(west, forKey: .west)
    }
    
    public mutating func set(value: T) {
        
        north = value
        east = value
        south = value
        west = value
    }
    
    public mutating func set(value: T, cardinal: Cardinal) {
        
        switch cardinal {
        
        case .north: north = value
        case .east: east = value
        case .south: south = value
        default: west = value
        }
    }
    
    public func value(for cardinal: Cardinal) -> T {
        
        switch cardinal {
        
        case .north: return north
        case .east: return east
        case .south: return south
        default: return west
        }
    }
}
