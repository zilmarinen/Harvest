//
//  HexagonalEntity.swift
//
//  Created by Zack Brown on 16/09/2025.
//

import Deltille
import RealityKit

public class HexagonalEntity: Entity,
                              @preconcurrency Codable {
   
   internal enum CodingKeys: CodingKey {
       
       case hexagon
       case scale
   }
    
    internal let hexagon: Hexagon
    internal let scale: Hexagon.Scale
    
    internal init(_ hexagon: Hexagon,
                  _ scale: Hexagon.Scale) {
        
        self.hexagon = hexagon
        self.scale = scale
        
        super.init()
        
        name = hexagon.id
        
        position = .init(hexagon.position(scale))
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.hexagon = try container.decode(Hexagon.self,
                                            forKey: .hexagon)
        
        self.scale = try container.decode(Hexagon.Scale.self,
                                          forKey: .scale)
        
        super.init()
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hexagon,
                             forKey: .hexagon)
        
        try container.encode(scale,
                             forKey: .scale)
    }
}
