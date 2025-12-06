//
//  HexagonalDataStore.swift
//
//  Created by Zack Brown on 29/11/2025.
//

import Deltille
import RealityKit

internal class HexagonalDataStore<C: TriangularChunk,
                                  V: Codable>: Entity {
    
    internal let dataSource = HexagonalGridDataSource<V>()
    
    internal let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    internal required init() {
        
        super.init()
        
        addChild(dataSource)
        addChild(grid)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle.Vertex) {
        
        dataSource.set(value,
                       for: key)
        
        grid.propagate(vertex: key)
    }
}

extension HexagonalDataStore {
    
    internal typealias Cleaner = ((_ slice: HexagonalGridDataSourceSlice<V>, _ chunk: C) -> Bool)
    
    internal func clean(_ cleaner: Cleaner) {
        
        var emptyRegions: [TriangularRegion<C>] = []
        
        for region in grid.dirtyRegions {
            
            var emptyChunks: [C] = []
            
            for chunk in region.dirtyChunks {
                
                let slice = dataSource.slice(for: chunk.triangle,
                                             .chunk)
                
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

extension HexagonalDataStore {
    
    internal func merge(_ slice: HexagonalDataSourceSlice<C, V>) {
        
        dataSource.merge(slice.dataSource)
        
        guard let region = slice.grid else { return }
        
        grid.merge(region)
    }
    
    internal func slice(region triangle: Triangle) -> HexagonalDataSourceSlice<C, V>? {
        
        .init(dataSource: dataSource.chunks(intersecting: triangle),
              grid: grid.region(for: triangle,
                                .region))
    }
}

extension HexagonalDataStore {
    
    internal func value(for key: Triangle.Vertex) -> V? {
        
        dataSource.value(for: key)
    }
    
    internal func slice(for chunk: Triangle,
                        _ scale: Triangle.Scale = .region) -> HexagonalGridDataSourceSlice<V> {
        
        dataSource.slice(for: chunk,
                         scale)
    }
    
    internal func tile(for triangle: Triangle) -> HexagonalGridDataSourceTile<V> {
        
        dataSource.tile(for: triangle)
    }
}

extension HexagonalDataStore {

    internal func propagate(vertex: Triangle.Vertex) {
        
        grid.propagate(vertex: vertex)
    }
}
