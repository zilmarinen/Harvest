//
//  EditorView.swift
//  Harvest
//
//  Created by Zack Brown on 19/11/2026.
//

import Metal
import MetalKit

@MainActor
internal class EditorView: MTKView,
                           MTKViewDelegate {
    
    private var camera = Camera(.zero,
                                1.0,
                                .zero)
    
    private let queue: MTLCommandQueue
    private let library: MTLLibrary
    
    internal init() {
        
        guard let device = MTLCreateSystemDefaultDevice(),
              let queue = device.makeCommandQueue() else {
            
            fatalError("Error initialising Metal device / queue")
        }
        
        do {
            
            self.queue = queue
            self.library = try device.makeDefaultLibrary(bundle: .module)
        }
        catch {
            
            fatalError("Error creating default Metal device library")
        }
        
        super.init(frame: .zero,
                   device: device)
        
        delegate = self
        
        clearColor = .init(red: 0.0125, green: 0.0125, blue: 0.0125, alpha: 1.0)
    }
    
    @available(*, unavailable)
    required public init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

internal extension EditorView {
    
    func mtkView(_ view: MTKView,
                 drawableSizeWillChange size: CGSize) {
        
        camera.viewport = .init(Float(size.width),
                                Float(size.height))
    }
    
    func draw(in view: MTKView) {
        
        guard let buffer = queue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let encoder = buffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        
        // Start

        //
        
        // End
        
        encoder.endEncoding()
        
        buffer.present(drawable)
        
        buffer.commit()
    }
}

private extension EditorView {
    
    func set<T>(vertexBytes value: T,
                index: Int,
                _ encoder: MTLRenderCommandEncoder) {
        
        withUnsafeBytes(of: value) { bytes in
            
            guard let base = bytes.baseAddress else { return }
            
            encoder.setVertexBytes(base,
                                   length: bytes.count,
                                   index: index)
        }
    }
    
    func set<T>(fragmentBytes value: T,
                index: Int,
                _ encoder: MTLRenderCommandEncoder) {
        
        withUnsafeBytes(of: value) { bytes in
            
            guard let base = bytes.baseAddress else { return }
            
            encoder.setFragmentBytes(base,
                                     length: bytes.count,
                                     index: index)
        }
    }
}
