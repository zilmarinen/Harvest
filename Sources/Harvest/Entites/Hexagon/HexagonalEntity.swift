//
//  HexagonalEntity.swift
//  Harvest
//
//  Created by Zack Brown on 16/09/2025.
//

import Deltille
import RealityKit

public class HexagonalEntity: Entity {
    
    internal let hexagon: Hexagon
    internal let scale: Hexagon.Scale
    
    internal init(_ hexagon: Hexagon,
                  _ scale: Hexagon.Scale) {
        
        self.hexagon = hexagon
        self.scale = scale
        
        super.init()
        
        name = hexagon.id
        
        position = .init(hexagon.position(scale))
        
        guard let entity = try? ModelEntity(hexagon.mesh(scale)) else { return }
        
        entity.position = -.init(hexagon.position(scale)) + [0.0, 0.03, 0.0]
        entity.model?.materials = [SimpleMaterial(color: .systemIndigo,
                                                  isMetallic: false)]
        
        addChild(entity)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
}
