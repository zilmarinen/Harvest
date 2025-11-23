//
//  Footpaths.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import Deltille
import RealityKit

internal class Footpaths: TriangularGrid<FootpathRegion,
                                         FootpathChunk> {
    
    internal let dataSource = HexagonalGridDataSource<FootpathType>()
    
    required internal init() {
        
        super.init()
        
        name = Entity.Identifier.footpaths.id
        
        addChild(dataSource)
    }
}

extension Footpaths {
    
    internal func value(for vertex: Triangle.Vertex) -> FootpathType? {
     
        dataSource.value(for: vertex)
    }
    
    internal func set(_ value: FootpathType?,
                      for vertex: Triangle.Vertex) {
     
        dataSource.set(value,
                       for: vertex)
        
        propagate(vertex: vertex)
    }
}
