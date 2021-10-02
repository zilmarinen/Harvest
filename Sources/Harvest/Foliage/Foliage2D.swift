//
//  Foliage2D.swift
//
//  Created by Zack Brown on 14/03/2021.
//

import Meadow
import SpriteKit

public class Foliage2D: PropGrid2D<FoliageChunk2D, FoliageTile2D> {
    
    struct Tilemap {
        
        let shader = SKShader(shader: .grid)
        
        init() {
            
            shader.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        }
    }
    
    let tilemap = Tilemap()
}
