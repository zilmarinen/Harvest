//
//  MTLRenderPipelineDescriptor.swift
//  Harvest
//
//  Created by Zack Brown on 20/11/2026.
//

import Metal

internal extension MTLRenderPipelineDescriptor {
    
    enum Function: String {
        
        case grid
        
        case mesh
        
        var id: String {
            
            rawValue
        }
        
        var fragment: String {
            
            rawValue + "Fragment"
        }
        
        var vertex: String {
            
            rawValue + "Vertex"
        }
    }
    
    convenience init(_ function: Function,
                     _ library: MTLLibrary) {
        
        self.init()
        
        fragmentFunction = library.makeFunction(name: function.fragment)
        vertexFunction = library.makeFunction(name: function.vertex)
        
        colorAttachments[0].pixelFormat = .bgra8Unorm
    }
}
