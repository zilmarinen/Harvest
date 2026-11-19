//
//  Camera.swift
//  Harvest
//
//  Created by Zack Brown on 19/11/2026.
//

import simd

internal struct Camera {
    
    internal var position: SIMD2<Float>
    internal var scale: Float
    internal var viewport: SIMD2<Float>
    
    internal init(_ position: SIMD2<Float> = .zero,
                  _ scale: Float = 1.0,
                  _ viewport: SIMD2<Float> = .zero) {
        
        self.position = position
        self.scale = scale
        self.viewport = viewport
    }
}
