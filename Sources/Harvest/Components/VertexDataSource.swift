//
//  VertexDataSource.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import RealityKit

internal class VertexDataSource<V: Codable>: Component,
                                             Codable {
    
    internal var vertices: [Triangle.Vertex : V] = [:]
    
    internal var isEmpty: Bool { vertices.isEmpty }
}

internal protocol HasVertexDataSource: HexagonalEntity {
    
    associatedtype V: Codable
    
    var dataSource: VertexDataSource<V> { get }
    
    var vertices: [Triangle.Vertex : V] { get }
    
    var isEmpty: Bool { get }
    
    func value(for vertex: Triangle.Vertex) -> V?
    
    func set(_ value: V?,
             for vertex: Triangle.Vertex)
    
    func merge(_ other: VertexDataSource<V>)
}

extension HasVertexDataSource {
    
    internal var vertices: [Triangle.Vertex : V] { dataSource.vertices }
    
    internal var isEmpty: Bool { dataSource.isEmpty }
}
