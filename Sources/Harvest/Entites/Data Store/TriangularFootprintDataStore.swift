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
        
        //
    }
    
    override func value(for key: Triangle) -> V? {
        
        let sieve = key.sieve(for: .chunk)
        
        for tile in sieve.tiles {
            
            //
        }
        
        return nil
    }
}
