//
//  TerrainRegion.swift
//  Harvest
//
//  Created by Zack Brown on 10/09/2025.
//

import Deltille
import Foundation
import RealityKit

public class TerrainRegion: TriangularRegion<TerrainChunk>,
                            @preconcurrency Codable,
                            HasSoilableComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case triangle
        case chunks
    }
    
    convenience init(empty triangle: Triangle) {
        
        self.init(triangle: triangle)
        
        let tile = triangle.transpose(.region,
                                      .tile)
        
        for vertex in tile.vertices {
            
            createChunks(for: vertex)
        }
    }
    
    public init(triangle: Triangle) {
        
        super.init(triangle,
                   .region)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let triangle = try container.decode(Triangle.self,
                                            forKey: .triangle)
        
        super.init(triangle,
                   .region)
        
        let children = try container.decode([TerrainChunk].self,
                                            forKey: .chunks)
        
        children.forEach { addChild($0) }
        
        guard let entity = try? ModelEntity(triangle.mesh(.region)) else { return }
        
        entity.position = -position
        entity.model?.materials = [SimpleMaterial(color: triangle.isPointy ? .systemIndigo : .systemTeal,
                                                  isMetallic: false)]
        addChild(entity)
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(triangle,
                             forKey: .triangle)
        
        try container.encode(chunks,
                             forKey: .chunks)
    }
}

extension TerrainRegion {
 
    internal var dirtyChunks: [TerrainChunk] {
        
        chunks.filter { $0.isDirty }
    }
}

extension TerrainRegion {
    
    internal func createChunks(for vertex: Triangle.Vertex) {
        
        let tiles = Set(vertex.tiles.compactMap {
            
            let region = $0.transpose(.tile,
                                      .region)
            
            let chunk = $0.transpose(.tile,
                                     .chunk)
            
            return region == triangle ? chunk : nil
        })
        
        for tile in tiles {
            
            let chunk = chunk(for: tile) ?? TerrainChunk(tile)
            
            if chunk.parent == nil {
                
                addChild(chunk)
            }
            
            chunk.becomeDirty()
        }
        
        becomeDirty()
    }
}
