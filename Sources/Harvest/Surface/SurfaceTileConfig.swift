//
//  SurfaceTileConfig.swift
//
//  Created by Zack Brown on 13/01/2022.
//

import Meadow

class SurfaceTileConfig {
    
    var pattern = GridPattern<SurfaceMaterial>(value: .air)
    var elevation = GridPattern<Int>(value: 0)
    var occupancy = OrdinalPattern<SurfaceSocket>(value: SurfaceSocket(inner: false, outer: false))
}

extension SurfaceTileConfig {
    
    func reset() {
        
        pattern.set(value: .air)
        elevation.set(value: World.Constants.floor)
        occupancy.set(value: SurfaceSocket(inner: true, outer: false))
    }
}

extension SurfaceTileConfig {
    
    typealias Chunk = (elevation: Int, material: SurfaceMaterial, pattern: OrdinalPattern<SurfaceSocket>)
    
    func chunks(for material: SurfaceMaterial) -> [Chunk] {
        
        let elevations = elevations(for: material)
        
        var chunks: [Chunk] = []
        
        for elevation in elevations {
            
            let ordinals = ordinals(for: material, at: elevation)
            
            guard !ordinals.isEmpty else { continue }
            
            var pattern = OrdinalPattern<SurfaceSocket>(value: SurfaceSocket(inner: false, outer: false))
            
            for ordinal in ordinals {
                
                pattern.set(value: SurfaceSocket(inner: true, outer: true), ordinal: ordinal)
            }
            
            chunks.append((elevation, material, pattern))
        }
        
        return chunks.sorted { $0.pattern.area > $1.pattern.area }
    }
    
    func ordinals(for material: SurfaceMaterial, at elevation: Int) -> [Ordinal] {
        
        return Ordinal.allCases.compactMap {
            
            guard pattern.value(for: $0) == material,
                  self.elevation.value(for: $0) == elevation else { return nil }
            
             return $0
        }
    }
    
    func elevations(for material: SurfaceMaterial) -> [Int] {
        
        let values = elevation.ordinals.values
        
        return Set(Ordinal.allCases.compactMap { pattern.value(for: $0) == material ? elevation.value(for: $0) : nil }).sorted { lhs, rhs in
            
            let c0 = values.filter { $0 == lhs }.count
            let c1 = values.filter { $0 == rhs }.count
            
            return c0 > c1
        }
    }
}
