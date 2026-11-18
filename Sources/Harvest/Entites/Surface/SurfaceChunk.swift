//
//  SurfaceChunk.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Alluvium
import Deltille
import Lattice
import SpriteKit

public class SurfaceChunk: TileChunk<Triangle> {
    
    internal let edges = SKShapeNode()
    internal let surface = SKShapeNode()
    
    internal required init(_ tile: Triangle,
                           _ lattice: Double) {
        
        super.init(tile,
                   lattice)
        
        addChild(surface)
        addChild(edges)
    }
}
