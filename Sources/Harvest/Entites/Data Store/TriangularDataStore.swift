//
//  TriangularDataStore.swift
//
//  Created by Zack Brown on 02/12/2025.
//

import Deltille
import RealityKit

internal class TriangularDataStore<C: TriangularChunk,
                                   V: Codable>: Entity {
    
    typealias R = TriangularRegionDataSource<TriangularChunkDataSource<V>, V>
    
    internal let dataSource = TriangularGridDataSource<R, TriangularChunkDataSource<V>, V>()
    
    internal let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    internal required init() {
        
        super.init()
        
        addChild(dataSource)
        addChild(grid)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle) {
        
        dataSource.set(value,
                       for: key)
        
        grid.propagate(triangle: key)
    }
    
    internal func value(for key: Triangle) -> V? {
        
        dataSource.value(for: key)
    }
}

extension TriangularDataStore {
    
    internal typealias Cleaner = ((_ dataSource: TriangularChunkDataSource<V>, _ chunk: C) -> Bool)
    
    internal func clean(_ cleaner: Cleaner) {
        
        var emptyRegions: [TriangularRegion<C>] = []
        
        for region in grid.dirtyRegions {
            
            var emptyChunks: [C] = []
            
            for chunk in region.dirtyChunks {
                
                guard let data = dataSource.chunk(for: chunk.triangle.transpose(.chunk,
                                                                                .tile)),
                      !data.isEmpty,
                      cleaner(data,
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

extension TriangularDataStore {
    
    internal func merge(_ slice: TriangularDataSourceSlice<C, V>) {
        
        dataSource.merge(slice.dataSource)
        
        guard let region = slice.grid else { return }
        
        grid.merge(region)
    }
    
    internal func slice(region: Triangle) -> TriangularDataSourceSlice<C, V>? {
        
        .init(dataSource: dataSource.chunks(intersecting: region),
              grid: grid.region(for: region))
    }
}

extension TriangularDataStore {
    
    
}

extension TriangularDataStore {
    
    internal func propagate(triangle: Triangle) {
        
        grid.propagate(triangle: triangle)
    }
    
    internal func propagate(vertex: Triangle.Vertex) {
        
        grid.propagate(vertex: vertex)
    }
}
