//
//  TriangularGridDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class TriangularGridDataSource<R: TriangularRegionDataSource<C, V>,
                                      C: TriangularChunkDataSource<V>,
                                      V: Codable>: TriangularGrid<R, C> {
    
    internal func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let match = $0.triangle.transpose(.chunk,
                                              .tile)
            
            let region = region(for: match) ?? R($0.triangle.transpose(.chunk,
                                                                       .region))
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
        }
    }
    
    internal func value(for key: Triangle) -> V? {
        
        guard let region = region(for: key) else { return nil }
        
        return region.value(for: key)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle) {
        
        let region = region(for: key) ?? R(key.transpose(.tile,
                                                         .region))
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: key)
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
}

//extension TriangularGridDataSource {
//    
//    internal func slice(for sieve: Triangle.Sieve) -> DataSourceSlice<V> {
//     
//        
//    }
//}
