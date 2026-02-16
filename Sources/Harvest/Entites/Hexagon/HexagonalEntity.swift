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
    
    public let hexagon: Hexagon
    public let scale: Hexagon.Scale
    
    internal init(_ hexagon: Hexagon,
                  _ scale: Hexagon.Scale) {
        
        self.hexagon = hexagon
        self.scale = scale
        
        super.init()
        
        name = hexagon.id
        
        updatePosition()
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
        
        name = hexagon.id
        
        updatePosition()
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hexagon,
                             forKey: .hexagon)
        
        try container.encode(scale,
                             forKey: .scale)
    }
}

extension HexagonalEntity {
    
    private func updatePosition() {
        
        switch scale {
            
        case .region:
            
            position = .init(hexagon.child().position(.chunk))
            
        case .chunk:
            
            let origin = hexagon.parent().child().position(scale)
            
            position = .init(hexagon.position(scale) - origin)
            
        default:
            
            position = .init(hexagon.position(scale))
        }
        
//        guard let entity = try? ModelEntity(hexagon.mesh(.chunk)) else { return }
//                
//        entity.position = -.init(hexagon.position(.chunk)) + [0.0, scale == .region ? 0.02 : 0.01, 0.0]
//        entity.model?.materials = [SimpleMaterial(color: scale == .region ? .systemIndigo : .systemPink,
//                                                  isMetallic: false)]
//        
//        addChild(entity)
    }
}
