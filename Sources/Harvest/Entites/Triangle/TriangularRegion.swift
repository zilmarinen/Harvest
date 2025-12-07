//
//  TriangularRegion.swift
//
//  Created by Zack Brown on 17/09/2025.
//

import Deltille
import RealityKit

public class TriangularRegion<C: TriangularChunk>: TriangularEntity,
                                                   HasSoilableComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case chunks
    }
    
    required internal init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .region)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let children = try container.decode([C].self,
                                            forKey: .chunks)
        
        children.forEach { addChild($0) }
    }
    
    public override func encode(to encoder: any Encoder) throws {
    
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(chunks,
                             forKey: .chunks)
    }
}

extension TriangularRegion {
    
    internal var isEmpty: Bool {
        
        chunks.isEmpty
    }
    
    internal var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
    
    internal var dirtyChunks: [C] {
        
        chunks.filter {
            
            $0.isDirty
        }
    }
}

extension TriangularRegion {
    
    internal func chunk(for triangle: Triangle,
                        _ scale: Triangle.Scale = .tile) -> C? {
        
        let match = triangle.transpose(scale,
                                       .chunk)
        
        return chunks.first {
            
            $0.triangle == match
        }
    }
    
    internal func chunks(intersecting triangle: Triangle,
                         _ scale: Triangle.Scale = .region) -> [C] {
        
        let match = triangle.transpose(scale,
                                       .chunk)
     
        return chunks.filter {
            
            $0.triangle == triangle
        }
    }
    
    internal func propagate(triangle: Triangle,
                            _ scale: Triangle.Scale = .tile) {
        
        let chunk = chunk(for: triangle,
                          scale) ?? .init(triangle.transpose(scale,
                                                             .chunk))
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.becomeDirty()
        
        becomeDirty()
    }
    
    internal func propagate(vertex: Triangle.Vertex) {
        
        let triangles = vertex.tiles.unique(.tile,
                                            .chunk)
        
        for triangle in triangles {
            
            propagate(triangle: triangle,
                      .chunk)
        }
    }
}
