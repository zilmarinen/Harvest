//
//  GridDataStore.swift
//
//  Created by Zack Brown on 20/12/2025.
//

import Deltille
import RealityKit

internal protocol GridDataStore: Entity {
    
    associatedtype C: TriangularChunk
    associatedtype G: TriangularGrid<TriangularRegion<C>, C>
    associatedtype K: Codable & Hashable
    associatedtype S: GridDataSourceSlice
    associatedtype V: Codable
    
    typealias Cleaner = ((_ slice: S, _ chunk: C) -> Bool)
    
    var grid: G { get }
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
    
    func remove(values keys: [K])
    
    func slice(for sieve: Triangle.Sieve) -> S
    
    func clean(_ cleaner: Cleaner)
}

extension GridDataStore {
    
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

extension GridDataStore {
    
    internal func propagate(triangle tile: Triangle) {
     
        grid.propagate(triangle: tile)
    }

    internal func propagate(vertex: Triangle.Vertex) {
        
        grid.propagate(vertex: vertex)
    }
}
