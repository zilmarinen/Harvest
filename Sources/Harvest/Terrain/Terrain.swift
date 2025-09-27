//
//  Terrain.swift
//  Harvest
//
//  Created by Zack Brown on 10/08/2025.
//

import Deltille
import Foundation
import RealityKit

public class Terrain: TriangularGrid<TerrainRegion,
                      TerrainChunk> {
    
    internal let heightMap = HeightMap()
    
    internal required init() {
        
        super.init()
        
        addChild(heightMap)
        
        components[TerrainCacheComponent.self] = .init()
    }
}

extension Terrain {
 
    internal var dirtyRegions: [TerrainRegion] {
        
        regions.filter { $0.isDirty }
    }
}

extension Terrain {
    
    public func get(value vertex: Triangle.Vertex) -> HeightMapVertex? {
        
        heightMap.get(value: vertex)
    }
    
    public func set(_ height: Int,
                    _ material: TerrainType,
                    for vertex: Triangle.Vertex) {
        
        heightMap.set(height,
                      material,
                      for: vertex)
        
        createRegions(for: vertex)
    }
}

extension Terrain {
    
    private func createRegions(for vertex: Triangle.Vertex) {
        
        let tiles = Set(vertex.tiles.map { $0.transpose(.tile,
                                                        .region) })
        
        for tile in tiles {
            
            let region = region(for: tile) ?? TerrainRegion(triangle: tile)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.createChunks(for: vertex)
        }
    }
}
