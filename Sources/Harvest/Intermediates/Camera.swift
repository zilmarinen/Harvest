//
//  Camera.swift
//  Harvest
//
//  Created by Zack Brown on 19/11/2026.
//

import Deltille
import simd

internal struct Camera {
    
    internal var position: SIMD2<Float> = .zero
    internal var viewport: SIMD2<Float> = .zero
    
    internal var triangle: Triangle = .zero {
        
        didSet {
            
            let vector = triangle.vertex.vector(zoomLevel.lattice)
            
            position = .init(vector)
        }
    }
    
    internal var zoomLevel: ZoomLevel = .x2
}

internal extension Camera {
    
    var lattice: Double {
        
        zoomLevel.lattice
    }
}
