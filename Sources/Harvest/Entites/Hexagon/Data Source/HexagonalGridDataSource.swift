//
//  HexagonalGridDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

internal class HexagonalGridDataSource<V: Codable>: HexagonalGrid<HexagonalRegionDataSource<HexagonalChunkDataSource<V>, V>,
                                                                  HexagonalChunkDataSource<V>> {
    
    internal typealias C = HexagonalChunkDataSource<V>
    internal typealias R = HexagonalRegionDataSource<C, V>
    
    internal func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let parent = $0.hexagon.parent()
            
            let region = region(for: parent) ?? R(parent)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
        }
    }
    
    internal func value(for key: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        guard let region = region(for: hexagon.parent()) else { return nil }
        
        return region.value(for: key)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle.Vertex) {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        let parent = hexagon.parent()
        
        let region = region(for: parent) ?? R(parent)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: key)
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
}

extension HexagonalGridDataSource {
    
    internal func slice(for triangle: Triangle,
                        _ scale: Triangle.Scale = .region) -> HexagonalGridDataSourceSlice<V> {
        
        let sieve = triangle.sieve(for: scale)
        
        let vertices = sieve.vertices.reduce(into: [Triangle.Vertex : V]()) { result, vertex in
            
            result[vertex] = value(for: vertex)
        }
        
        return .init(sieve: sieve,
                     vertices: vertices)
    }
    
    internal func tile(for triangle: Triangle) -> HexagonalGridDataSourceTile<V> {
        
        let vertices = triangle.vertices.reduce(into: [Triangle.Vertex : V]()) { result, vertex in
            
            result[vertex] = value(for: vertex)
        }
        
        return .init(triangle: triangle,
                     vertices: vertices)
    }
}
