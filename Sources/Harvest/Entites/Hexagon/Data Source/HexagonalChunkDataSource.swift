//
//  HexagonalChunkDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class HexagonalChunkDataSource<V: Codable>: HexagonalEntity,
                                                   HasVertexDataSource {
    
    internal enum CodingKeys: CodingKey {
        
        case dataSource
    }
    
    internal let dataSource: VertexDataSource<V>
    
    required internal init(_ hexagon: Hexagon) {
        
        self.dataSource = .init()
        
        super.init(hexagon,
                   .chunk)
        
        components.set(dataSource)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dataSource = try container.decode(VertexDataSource<V>.self,
                                               forKey: .dataSource)
        
        try super.init(from: decoder)
        
        components.set(dataSource)
    }
    
    public override func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dataSource,
                             forKey: .dataSource)
    }
}

extension HexagonalChunkDataSource {
    
    internal func value(for vertex: Triangle.Vertex) -> V? {
        
        dataSource.vertices[vertex]
    }
    
    internal func set(_ value: V?,
                      for vertex: Triangle.Vertex) {
        
        guard let value,
              Hexagon(vertex.position(.tile),
                      .chunk) == hexagon else {
            
            dataSource.vertices.removeValue(forKey: vertex)
            
            return
        }
        
        dataSource.vertices[vertex] = value
    }
    
    internal func merge(_ other: VertexDataSource<V>) {
        
        dataSource.vertices.merge(other.vertices) { (current, _) in current }
    }
}
