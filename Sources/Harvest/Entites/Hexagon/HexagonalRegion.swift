//
//  HexagonalRegion.swift
//
//  Created by Zack Brown on 24/10/2025.
//

import Deltille
import RealityKit

public class HexagonalRegion<C: HexagonalChunk<V>,
                             V: Codable>: HexagonalEntity {
    
    internal enum CodingKeys: CodingKey {
        
        case chunks
    }
    
    required internal init(_ hexagon: Hexagon) {
        
        super.init(hexagon,
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
    
    internal func merge(_ chunk: C) {
        
        guard let existing = self.chunk(for: chunk.hexagon) else {
        
            addChild(chunk)
            
            return
        }
        
        existing.merge(chunk.dataSource)
        
        guard let existing = existing as? HasSoilableComponent else { return }
        
        existing.becomeDirty()
    }
}

extension HexagonalRegion {
    
    internal var isEmpty: Bool {
        
        chunks.isEmpty
    }
    
    internal var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

extension HexagonalRegion {
    
    internal func value(for vertex: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon) else { return nil }
        
        return chunk.value(for: vertex)
    }
    
    internal func set(_ value: V?,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon) ?? C(hexagon)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(value,
                  for: vertex)
        
        if let chunk = chunk as? HasSoilableComponent {
         
            chunk.becomeDirty()
        }
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
    
    internal func chunk(for hexagon: Hexagon) -> C? {
        
        chunks.first {
            
            $0.hexagon == hexagon
        }
    }
    
    internal func chunks(intersecting triangle: Triangle) -> [C] {
        
        chunks.filter {
            
            for vertex in $0.hexagon.vertices {
                
                let other = Triangle(vertex.position(.chunk),
                                     .region)
                
                if other == triangle {
                    
                    return true
                }
            }
            
            for vertex in triangle.vertices {
                
                let other = Hexagon(vertex.position(.region),
                                    .chunk)
                
                if other == $0.hexagon {
                    
                    return true
                }
            }
            
            return false
        }
    }
}
