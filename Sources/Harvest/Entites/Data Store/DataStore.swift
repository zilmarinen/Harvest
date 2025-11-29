//
//  DataStore.swift
//
//  Created by Zack Brown on 29/11/2025.
//

import Deltille
import RealityKit

internal class DataStore<C: TriangularChunk,
                         V: Codable>: Entity {
    
    internal let dataSource = HexagonalGridDataSource<V>()
    
    internal let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    internal required init() {
        
        super.init()
        
        addChild(dataSource)
        addChild(grid)
    }
}

extension DataStore {
    
    internal func merge(slice: DataSourceSlice<C, V>) {
        
        dataSource.merge(slice.chunks)
        
        guard let region = slice.region else { return }
        
        //TODO: Check region does not exists and merge region chunks
        grid.addChild(region)
    }
    
    internal func slice(region triangle: Triangle) -> DataSourceSlice<C, V>? {
        
        .init(region: grid.region(for: triangle),
              chunks: dataSource.chunks(intersecting: triangle))
    }
}

extension DataStore {
    
    internal func value(for vertex: Triangle.Vertex) -> V? {
        
        dataSource.value(for: vertex)
    }
    
    internal func set(_ value: V?,
                      for vertex: Triangle.Vertex) {
        
        dataSource.set(value,
                       for: vertex)
        
        grid.propagate(vertex: vertex)
    }
    
    internal func slice(for chunk: Triangle) -> HexagonalGridDataSourceSlice<V> {
        
        dataSource.slice(for: chunk)
    }
    
    internal func tile(for triangle: Triangle) -> HexagonalGridDataSourceTile<V> {
        
        dataSource.tile(for: triangle)
    }
}

extension DataStore {
    
    internal var isEmpty: Bool {
        
        grid.isEmpty
    }
    
    internal var regions: [TriangularRegion<C>] {
        
        grid.regions
    }
    
    internal var dirtyRegions: [TriangularRegion<C>] {
        
        grid.dirtyRegions
    }
    
    internal func propagate(vertex: Triangle.Vertex) {
     
        grid.propagate(vertex: vertex)
    }
}
