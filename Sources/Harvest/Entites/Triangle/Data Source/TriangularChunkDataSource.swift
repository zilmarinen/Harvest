//
//  TriangularChunkDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class TriangularChunkDataSource<V: Codable>: TriangularChunk,
                                                    HasDataSource {
    
    internal enum CodingKeys: CodingKey {
        
        case dataSource
    }
    
    internal let dataSource: DataSource<Triangle, V>
    
    required internal init(_ triangle: Triangle) {
        
        self.dataSource = .init()
        
        super.init(triangle)
        
        components.set(dataSource)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dataSource = try container.decode(DataSource<Triangle, V>.self,
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

extension TriangularChunkDataSource {
    
    internal func set(_ value: V?,
                      for key: K) {
        
        guard let value,
              key.transpose(.tile,
                            .chunk) == triangle else {
            
            dataSource.data.removeValue(forKey: key)
            
            return becomeDirty()
        }
        
        dataSource.data[key] = value
        
        becomeDirty()
    }
}
