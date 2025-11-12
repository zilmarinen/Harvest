//
//  TriangularChunk.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import RealityKit

public class TriangularChunk<T: Codable>: TriangularEntity,
                                          HasTileDataSource {
    
    internal enum CodingKeys: CodingKey {
        
        case dataSource
    }
    
    internal let dataSource: TileDataSource<T>
    
    required internal init(_ triangle: Triangle) {
        
        self.dataSource = .init()
        
        super.init(triangle,
                   .chunk)
        
        components.set(dataSource)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dataSource = try container.decode(TileDataSource<T>.self,
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

extension TriangularChunk {
    
    internal func value(for tile: Triangle) -> T? {
        
        dataSource.tiles[tile]
    }
    
    internal func set(_ value: T?,
                      for tile: Triangle) {
        
        guard let value else {
            
            dataSource.tiles.removeValue(forKey: tile)
            
            return
        }
        
        dataSource.tiles[tile] = value
    }
}
