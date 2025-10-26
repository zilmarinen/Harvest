//
//  BiomeChunk.swift
//
//  Created by Zack Brown on 17/10/2025.
//

import Deltille
import RealityKit

internal class BiomeChunk: HexagonalEntity,
                           HasBiomeComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case biomes
    }
    
    internal init(_ hexagon: Hexagon) {
    
        super.init(hexagon,
                   .chunk)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    internal required init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.biomeComponent = try container.decode(BiomeComponent.self,
                                                   forKey: .biomes)
    }
    
    internal override func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(biomeComponent,
                             forKey: .biomes)
    }
}
