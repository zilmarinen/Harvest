//
//  BiomeChunk.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille
import RealityKit

internal class BiomeChunk: HexagonalEntity,
                           @preconcurrency Codable,
                           HasBiomeComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case hexagon
        case biomes
    }
    
    internal init(_ hexagon: Hexagon) {
    
        super.init(hexagon,
                   .chunk)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    internal required init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let hexagon = try container.decode(Hexagon.self,
                                           forKey: .hexagon)
        
        super.init(hexagon,
                   .chunk)
        
        self.biomeComponent = try container.decode(BiomeComponent.self,
                                                   forKey: .biomes)
    }
    
    internal func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hexagon,
                             forKey: .hexagon)
        
        try container.encode(biomeComponent,
                             forKey: .biomes)
    }
}
