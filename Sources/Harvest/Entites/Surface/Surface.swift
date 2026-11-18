//
//  Surface.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import CoreGraphics
import Deltille
import Lattice

internal class Surface: VertexLattice<SurfaceChunk, SurfaceVertex> {
    
    override func clean(_ chunk: SurfaceChunk,
                        _ sieve: Triangle.Sieve,
                        _ wedge: DataStoreWedge<Triangle.Vertex, SurfaceVertex>) -> CGPath {
        
        print("Cleaning surface chunk \(chunk.tile.id)")
        
        let weave = wedge.weave(sieve)
        
        return weave.data.reduce(into: CGMutablePath()) { path, element in
            
            let (tile, stitch) = element
            
            let vertices = tile.vertices()
            
            guard let moveTo = vertices.last else { return }
            
            path.move(to: moveTo.vector(lattice))
            
            for vertex in vertices {
                
                path.addLine(to: vertex.vector(lattice))
            }
        }
    }
}
