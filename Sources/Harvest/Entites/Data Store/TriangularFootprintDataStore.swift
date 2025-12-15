//
//  TriangularFootprintDataStore.swift
//
//  Created by Zack Brown on 05/12/2025.
//

import Deltille
import RealityKit

internal class TriangularFootprintDataStore<C: TriangularChunk,
                                            V: HasTriangleFootprint>: TriangularDataStore<C, V> {
    
    override func set(_ value: V?,
                      for key: Triangle) {
        
        guard let value else {
            
            guard let existing = self.value(for: key) else { return }
            
            print("Removing existing tiles for \(existing.origin.id)")
            return existing.footprint.tiles.forEach {
                
                super.set(value,
                          for: $0)
            }
        }
        
        for tile in value.footprint.tiles {
            
            guard self.value(for: tile) == nil else { return }
        }
        print("Adding new tiles for \(key.id)")
        for tile in value.footprint.tiles {
            
            super.set(value,
                      for: tile)
        }
    }
}
