//
//  TerrainRegion.swift
//  Harvest
//
//  Created by Zack Brown on 10/09/2025.
//

import Deltille
import Foundation
import RealityKit

public class TerrainRegion: Entity,
                            @preconcurrency Codable {
    
    internal enum CodingKeys: CodingKey {
        
        case triangle
        case chunks
    }
    
    internal let triangle: Triangle
    internal let soilableComponent = SoilableComponent()
    
    convenience init(empty triangle: Triangle) {
        
        self.init(triangle: triangle)
        
        let tile = triangle.transpose(.region,
                                      .tile)
        
        for vertex in tile.vertices {
            
            createChunks(for: vertex)
        }
    }
    
    public init(triangle: Triangle) {
        
        self.triangle = triangle
        
        super.init()
        
        position = .init(triangle.position(.region))
        name = triangle.id
        
        components[SoilableComponent.self] = soilableComponent
        
        guard let entity = try? ModelEntity(triangle.mesh(.region)) else { return }
        
        entity.position = -position
        entity.model?.materials = [SimpleMaterial(color: triangle.isPointy ? .systemIndigo : .systemTeal,
                                                  isMetallic: false)]
        addChild(entity)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.triangle = try container.decode(Triangle.self,
                                             forKey: .triangle)
        
        super.init()
        
        position = .init(triangle.position(.region))
        name = triangle.id
        
        components[SoilableComponent.self] = soilableComponent
        
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
        
        try container.encode(triangle, forKey: .triangle)
        try container.encode(chunks, forKey: .chunks)
    }
}

extension TerrainRegion {
    
    internal var chunks: [TerrainChunk] {
        
        children.compactMap {
            
            $0 as? TerrainChunk
        }
    }
 
    internal var dirtyChunks: [TerrainChunk] {
        
        chunks.filter { $0.soilableComponent.isDirty }
    }
    
    internal var isEmpty: Bool {
        
        chunks.isEmpty
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
            
            let chunk = chunk(for: tile) ?? TerrainChunk(triangle: tile)
            
            if chunk.parent == nil {
                
                addChild(chunk)
            }
        }
    }
    
    internal func chunk(for triangle: Triangle) -> TerrainChunk? {
        
        chunks.first {
            
            $0.triangle == triangle
        }
    }
}
