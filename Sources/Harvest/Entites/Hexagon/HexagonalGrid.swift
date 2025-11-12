//
//  HexagonalGrid.swift
//
//  Created by Zack Brown on 17/09/2025.
//

import Deltille
import RealityKit

internal class HexagonalGrid<R: HexagonalRegion<C, V>,
                             C: HexagonalChunk<V>,
                             V: Codable>: Entity {
    
    internal func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let parent = $0.hexagon.parent()
            
            let region = region(for: parent) ?? R(parent)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
            
            guard let region = region as? HasSoilableComponent else { return }
            
            region.becomeDirty()
        }
    }
}

extension HexagonalGrid {
    
    internal var isEmpty: Bool {
        
        regions.isEmpty
    }
    
    internal var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

extension HexagonalGrid {
    
    internal func value(for vertex: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        guard let region = region(for: hexagon.parent()) else { return nil }
        
        return region.value(for: vertex)
    }
    
    internal func set(_ value: V?,
                      for vertex: Triangle.Vertex) {
        
        let hexagon = Hexagon(vertex.position(.tile),
                              .chunk)
        
        let parent = hexagon.parent()
        
        let region = region(for: parent) ?? R(parent)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: vertex)
        
        if let region = region as? HasSoilableComponent {
         
            region.becomeDirty()
        }
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
    
    internal func region(for hexagon: Hexagon) -> R? {
        
        regions.first {
            
            $0.hexagon == hexagon
        }
    }
    
    internal func chunks(intersecting triangle: Triangle) -> [C] {
        
        regions.flatMap {
         
            $0.chunks(intersecting: triangle)
        }
    }
}
