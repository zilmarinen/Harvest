//
//  TerrainRegion.swift
//
//  Created by Zack Brown on 10/09/2025.
//

import Deltille
import Foundation
import RealityKit

internal class TerrainRegion: TriangularRegion<TerrainChunk>,
                              HasSoilableComponent {
    
    internal convenience init(empty triangle: Triangle) {
        
        self.init(triangle)
        
        let tile = triangle.transpose(.region,
                                      .tile)
        
        for vertex in tile.vertices {
            
            terraform(vertex: vertex)
        }
    }
    
    internal override init(_ triangle: Triangle) {
        
        super.init(triangle)
    }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

extension TerrainRegion {
 
    internal var dirtyChunks: [TerrainChunk] {
        
        chunks.filter { $0.isDirty }
    }
}

extension TerrainRegion {
    
    internal func terraform(vertex: Triangle.Vertex) {
        
        let triangles = Set(vertex.tiles.compactMap {
            
            let region = $0.transpose(.tile,
                                      .region)
            
            return region == triangle ? $0 : nil
        })
        
        for triangle in triangles {
            
            let chunk = chunk(for: triangle) ?? .init(triangle.transpose(.tile,
                                                                         .chunk))
            
            if chunk.parent == nil {
                
                addChild(chunk)
            }
            
            chunk.becomeDirty()
        }
        
        becomeDirty()
    }
}
