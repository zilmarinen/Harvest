//
//  Terrain.swift
//
//  Created by Zack Brown on 10/08/2025.
//

import Deltille
import Foundation
import RealityKit

internal class Terrain: TriangularGrid<TerrainRegion,
                                       TerrainChunk> {
    
    internal required init() {
        
        super.init()
        
        name = Entity.Identifier.terrain.id
    }
}

extension Terrain {
 
    internal var dirtyRegions: [TerrainRegion] {
        
        regions.filter { $0.isDirty }
    }
}

extension Terrain {
    
    internal func terraform(vertex: Triangle.Vertex) {
        
        for triangle in vertex.tiles {
            
            let region = region(for: triangle) ?? .init(triangle.transpose(.tile,
                                                                           .region))
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.terraform(vertex: vertex)
        }
    }
}
