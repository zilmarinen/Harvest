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
}

extension HexagonalGridDataSource {
    
    internal func value(for vertex: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let region = region(for: hexagon.parent()) else { return nil }
        
        return region.value(for: vertex)
    }
    
    internal func set(_ value: V?,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let parent = hexagon.parent()
        
        let region = region(for: parent) ?? R(parent)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: vertex)
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
}

extension HexagonalGridDataSource {
    
    internal func slice(for chunk: Triangle) -> HexagonalGridDataSourceSlice<V> {
        
        let sieve = chunk.sieve(for: .chunk)
        
        let vertices = sieve.vertices.reduce(into: [Triangle.Vertex : V]()) { result, vertex in
            
            guard let value = value(for: vertex) else { return }
            
            result[vertex] = value
        }
        
        return .init(sieve: sieve,
                     vertices: vertices)
    }
    
    internal func tile(for triangle: Triangle) -> HexagonalGridDataSourceTile<V> {
        
        let vertices = triangle.vertices.compactMap {
            
            value(for: $0)
        }
        
        return .init(triangle: triangle,
                     vertices: vertices)
    }
}
