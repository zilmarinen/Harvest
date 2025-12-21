//
//  GridDataStore.swift
//
//  Created by Zack Brown on 20/12/2025.
//

import Deltille
import RealityKit

internal protocol GridDataStore: Entity {
    
    associatedtype C: TriangularChunk
    associatedtype K
    associatedtype S: GridDataSourceSlice
    associatedtype V: Codable
    
    var grid: TriangularGrid<TriangularRegion<C>, C> { get }
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
    
    func slice(for sieve: Triangle.Sieve) -> S
}

extension GridDataStore {
    
    internal typealias Cleaner = ((_ slice: S, _ chunk: C) -> Bool)
    
    internal func clean(_ cleaner: Cleaner) {
        
        var emptyRegions: [TriangularRegion<C>] = []
        
        for region in grid.dirtyRegions {
            
            var emptyChunks: [C] = []
            
            for chunk in region.dirtyChunks {
                
                let slice = self.slice(for: chunk.triangle.sieve(for: .chunk))
                
                guard !slice.isEmpty,
                      cleaner(slice,
                              chunk) else {
                    
                    emptyChunks.append(chunk)
                    
                    continue
                }
                
                chunk.isDirty = false
            }
            
            emptyChunks.forEach {
                
                $0.removeFromParent()
            }
            
            region.isDirty = false
            
            guard region.isEmpty else { continue }
            
            emptyRegions.append(region)
        }
        
        emptyRegions.forEach {
            
            $0.removeFromParent()
        }
    }
}
