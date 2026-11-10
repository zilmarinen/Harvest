//
//  Surface.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import Lattice

internal class Surface: VertexLattice<SurfaceChunk, SurfaceVertex> {
    
    override func clean(_ chunk: SurfaceChunk,
                        _ sieve: Triangle.Sieve,
                        _ wedge: DataStoreWedge<Triangle.Vertex, SurfaceVertex>) -> Bool {
        
        false
    }
}
