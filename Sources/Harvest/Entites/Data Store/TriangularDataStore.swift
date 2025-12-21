//
//  TriangularDataStore.swift
//
//  Created by Zack Brown on 02/12/2025.
//

import Deltille
import RealityKit

internal class TriangularDataStore<C: TriangularChunk,
                                   V: Codable>: Entity,
                                                GridDataStore {
    
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
    
    internal func slice(for sieve: Triangle.Sieve) -> TriangularGridDataSourceSlice<V> {
    
        dataSource.slice(for: sieve)
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
              grid: grid.region(for: region.transpose(.region,
                                                      .tile)))
    }
}

extension TriangularDataStore {
    
    internal func propagate(triangle: Triangle) {
        
        grid.propagate(triangle: triangle)
    }
    
    internal func propagate(vertex: Triangle.Vertex) {
        
        grid.propagate(vertex: vertex)
    }
}
