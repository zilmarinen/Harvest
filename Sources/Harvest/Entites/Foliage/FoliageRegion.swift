//
//  FoliageRegion.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import Deltille
import Foundation
import RealityKit

internal class FoliageRegion: TriangularRegion<FoliageChunk>,
                              @preconcurrency Codable,
                              HasSoilableComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case triangle
        case chunks
    }
    
    internal init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .region)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let triangle = try container.decode(Triangle.self,
                                            forKey: .triangle)
        
        super.init(triangle,
                   .region)
        
        let children = try container.decode([TerrainChunk].self,
                                            forKey: .chunks)
        
        children.forEach { addChild($0) }
    }
    
    internal func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(triangle,
                             forKey: .triangle)
        
        try container.encode(chunks,
                             forKey: .chunks)
    }
}

extension FoliageRegion {
 
    internal var dirtyChunks: [FoliageChunk] {
        
        chunks.filter { $0.isDirty }
    }
}

extension FoliageRegion {
    
    internal func set(foliage triangle: Triangle) {
        
        let parent = triangle.transpose(.tile,
                                        .chunk)
        
        let chunk = chunk(for: parent) ?? .init(parent)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(foliage: triangle)
        
        chunk.becomeDirty()
    }
}
