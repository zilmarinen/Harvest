//
//  Terrain.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Bivouac
import SceneKit

public final class Terrain: Dual<TerrainRegion, TerrainChunk>,
                            Cleanable {
    
    internal var isDirty: Bool = false
    
    internal var heightMap = TerrainHeightMap()
    
    internal var operationQueue = OperationQueue()
}

extension Terrain {
    
    public func set(elevation: Int,
                    terrainType: TerrainType,
                    for triangle: Grid.Triangle,
                    vertex: Grid.Triangle.Vertex) {
        
        guard let vertex = add(vertex: triangle.vertex(vertex)) else { return }
        
        heightMap.set(elevation: elevation,
                      terrainType: terrainType,
                      for: vertex)
        
        for triangle in vertex.triangles {
            
            guard let region = find(region: triangle.position.convert(from: .tile,
                                                                      to: .region)),
                  
                  let chunk = region.find(chunk: triangle.position.convert(from: .tile,
                                                                           to: .chunk)) else { continue }
            
            chunk.becomeDirty()
        }
    }
}

extension Terrain {
    
    internal func clean() {
    
        guard isDirty,
              operationQueue.operationCount == 0 else { return }
        
        isDirty = false
        
        let dirtyRegions = regions.filter { $0.isDirty }
        let dirtyChunks = dirtyRegions.flatMap { $0.chunks.filter { $0.isDirty } }
        
        let renderOperation = TerrainKiteRenderOperation()
        let tilingOperation = TerrainTilingOperation(chunks: dirtyChunks,
                                                     heightMap: heightMap)
        
        renderOperation.passesResult(to: tilingOperation).enqueue(on: operationQueue)
        
        dirtyRegions.forEach { $0.isDirty = false }
        dirtyChunks.forEach { $0.isDirty = false }
    }
}
