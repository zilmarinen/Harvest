//
//  TerrainSystem.swift
//  Harvest
//
//  Created by Zack Brown on 27/08/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

@MainActor
internal struct TerrainSystem: System {
    
    private static let query = EntityQuery(where: .has(TerrainComponent.self))
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let terrain = entity as? Terrain else { continue }
            
            var emptyRegions: [TerrainRegion] = []
            
            for region in terrain.dirtyRegions {
                
                var emptyChunks: [TerrainChunk] = []
                
                for chunk in region.dirtyChunks {
                    
                    let slice = terrain.heightMap.slice(for: chunk.triangle)
                    
                    guard !slice.vertices.isEmpty else {
                        
                        emptyChunks.append(chunk)
                        
                        continue
                    }
                    
                    update(chunk: chunk,
                           slice: slice)
                }
                
                emptyChunks.forEach {
                    
                    region.removeChild($0)
                }
                
                if region.isEmpty {
                    
                    emptyRegions.append(region)
                }
            }
            
            emptyRegions.forEach {
                
                terrain.removeChild($0)
            }
        }
    }
}

extension TerrainSystem {
    
    private func update(chunk: TerrainChunk,
                        slice: HeightMapSlice) {
        
        for (vertex, heightMap) in slice.vertices {
            
            for triangle in vertex.tiles {
                
                let tile = triangle.transpose(.tile,
                                              .chunk)
                
                guard tile == chunk.triangle else { continue }
                
                //
            }
        }
        
        chunk.isDirty = false
    }
}
