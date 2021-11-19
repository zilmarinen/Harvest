//
//  SurfaceSockets.swift
//
//  Created by Zack Brown on 16/11/2021.
//

import Meadow

public struct SurfaceSockets<T: Codable & Equatable>: Codable, Equatable {
    
    public var upper: OrdinalPattern<T>
    public var lower: OrdinalPattern<T>
    
    public init(value: T) {
        
        self.upper = OrdinalPattern(value: value)
        self.lower = OrdinalPattern(value: value)
    }
    
    public init(upper: OrdinalPattern<T>, lower: OrdinalPattern<T>) {
        
        self.upper = upper
        self.lower = lower
    }
    
    public mutating func set(value: T, ordinal: Ordinal) {
        
        upper.set(value: value, ordinal: ordinal)
        lower.set(value: value, ordinal: ordinal)
    }
}
