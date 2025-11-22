//
//  TriangularGridDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

import Deltille
import RealityKit

public class TriangularGridDataSource<R: TriangularRegionDataSource<C, T>,
                                      C: TriangularChunkDataSource<T>,
                                      T: Codable>: TriangularGrid<R, C> {}

extension TriangularGridDataSource {
    
    internal func value(for tile: Triangle) -> T? {
        
        guard let region = region(for: tile) else { return nil }
        
        return region.value(for: tile)
    }
    
    internal func set(_ value: T?,
                      for tile: Triangle) {
        
        let region = region(for: tile) ?? R(tile.transpose(.tile,
                                                           .region))
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: tile)
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
}
