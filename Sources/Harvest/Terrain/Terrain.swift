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
        
        components[TerrainCacheComponent.self] = .init()
    }
}

extension Terrain {
 
    internal var dirtyRegions: [TerrainRegion] {
        
        regions.filter { $0.isDirty }
    }
}

extension Terrain {
    
    internal func terraform(vertex: Triangle.Vertex) {
        
        let tiles = Set(vertex.tiles.map {
            
            $0.transpose(.tile,
                         .region)
        })
        
        for tile in tiles {
            
            let region = region(for: tile) ?? TerrainRegion(triangle: tile)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.terraform(vertex: vertex)
        }
    }
}
