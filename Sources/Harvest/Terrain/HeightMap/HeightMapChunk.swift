//
//  HeightMapChunk.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import RealityKit

internal class HeightMapChunk: HexagonalEntity,
                               @preconcurrency Codable,
                               HasHeightMapChunkComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case hexagon
        case vertices
    }
    
    internal init(_ hexagon: Hexagon) {
    
        super.init(hexagon,
            .chunk)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    internal required init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let hexagon = try container.decode(Hexagon.self,
                                           forKey: .hexagon)
        
        super.init(hexagon,
                   .chunk)
        
        self.heightMapChunkComponent = try container.decode(HeightMapChunkComponent.self,
                                                            forKey: .vertices)
    }
    
    internal func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hexagon,
                             forKey: .hexagon)
        
        try container.encode(heightMapChunkComponent,
                             forKey: .vertices)
    }
}
