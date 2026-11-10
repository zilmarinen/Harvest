//
//  Region.swift
//  Harvest
//
//  Created by Zack Brown on 31/10/2026.
//

import Deltille
import Lattice

public struct Region: Codable, Equatable, Hashable {
    
    public let triangle: Triangle
    
    public let surface: LatticeSlice<SurfaceChunk, Hexagon, Triangle, SurfaceVertex>?
    public let water: LatticeSlice<WaterChunk, Triangle, Triangle, WaterTile>?
    
    public init(empty triangle: Triangle) {
        
        self.triangle = triangle
        self.surface = nil
        self.water = nil
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(triangle)
    }
    
    public static func == (lhs: Region,
                           rhs: Region) -> Bool {
        
        lhs.triangle == rhs.triangle
    }
}

public extension Region {
 
    var isEmpty: Bool {
        
        (surface?.isEmpty ?? true) &&
        (water?.isEmpty ?? true)
    }
}

public extension Region {
    
    @MainActor
    func remove(values sieve: Triangle.Sieve) {
        
        let tiles = sieve.tiles
        let vertices = sieve.vertices
        
        surface?.remove(keys: vertices)
        water?.remove(keys: tiles)
    }
}
