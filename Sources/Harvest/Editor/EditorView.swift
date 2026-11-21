//
//  EditorView.swift
//  Harvest
//
//  Created by Zack Brown on 19/11/2026.
//

import Bivouac
import Deltille
import Euclid
import Metal
import MetalKit

@MainActor
internal class EditorView: MTKView,
                           MTKViewDelegate {
    
    internal private(set) var showGrid: Bool = true
    
    private var camera = Camera()
    internal var hit: HitTest = .init(.zero)
    
    private let gridPipeline: MTLRenderPipelineState
    private let meshPipeline: MTLRenderPipelineState
    
    private let queue: MTLCommandQueue
    private let library: MTLLibrary
    
    internal init() {
        
        do {
            
            guard let device = MTLCreateSystemDefaultDevice(),
                  let queue = device.makeCommandQueue() else { throw CocoaError(.featureUnsupported) }
            
            self.queue = queue
            self.library = try device.makeDefaultLibrary(bundle: .module)
            self.gridPipeline = try device.makeRenderPipelineState(descriptor: .init(.grid,
                                                                                     library))
            self.meshPipeline = try device.makeRenderPipelineState(descriptor: .init(.mesh,
                                                                                     library))
            
            super.init(frame: .zero,
                       device: device)
            
            delegate = self
        }
        catch {
            
            fatalError("Error creating default Metal device / library / queue: \(error)")
        }
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
        
        // MARK: Grid
        
        encoder.setRenderPipelineState(gridPipeline)
        
        set(fragmentBytes: camera.position,
            index: 0,
            encoder)
        
        set(fragmentBytes: camera.viewport,
            index: 1,
            encoder)
        
        set(fragmentBytes: Float(camera.zoomLevel.lattice),
            index: 2,
            encoder)
        
        set(fragmentBytes: Float(showGrid ? 1.0 : 0.0),
            index: 3,
            encoder)
        
        encoder.drawPrimitives(type: .triangle,
                               vertexStart: 0,
                               vertexCount: 3)
        
        // MARK: Scene
        encoder.setRenderPipelineState(meshPipeline)
        
        set(vertexBytes: camera.position,
            index: 0,
            encoder)
        
        set(vertexBytes: camera.viewport,
            index: 1,
            encoder)
        
        set(vertexBytes: Float(camera.zoomLevel.lattice),
            index: 2,
            encoder)
        
        // Debug
        let triangle = hit.triangle
        let tiles = [triangle] + triangle.adjacent
        let vertices: [Vertex2D] = tiles.flatMap {
            
            let color = SIMD4<Float>(Float(abs($0.x)), Float(abs($0.y)), Float(abs($0.z)), 1.0)
            
            return $0.vertices().map {
                
                let vector = $0.vector(lattice)
                
                return Vertex2D(.init(Float(vector.x),
                                      Float(vector.z)),
                                color)
            }
        }
        
        let mesh = Mesh2D(vertices)
        
        if let meshBuffer = device?.makeBuffer(bytes: mesh.vertices,
                                               length: mesh.length) {
            
            encoder.setVertexBuffer(meshBuffer,
                                    offset: 0,
                                    index: 3)
            
            encoder.drawPrimitives(type: .triangle,
                                   vertexStart: 0,
                                   vertexCount: mesh.vertexCount)
        }
        
        // MARK: Render
        
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

internal extension EditorView {
 
    func hit(_ point: CGPoint) -> HitTest {
        
        let scale = window?.backingScaleFactor ?? 1.0
        let viewport = CGSize(width: Double(camera.viewport.x),
                              height: Double(camera.viewport.y))
        let position = CGPoint(x: Double(camera.position.x),
                               y: Double(camera.position.y))
        
        let pixel = CGPoint(x: point.x * scale,
                            y: viewport.height - point.y * scale)
        
        let x = pixel.x - viewport.width / 2.0
        let y = pixel.y - viewport.height / 2.0
        
        let vector = Vector(x / CGFloat(lattice) + position.x,
                            0.0,
                            y / CGFloat(lattice) + position.y)
        
        return .init(vector,
                     lattice)
    }
}

internal extension EditorView {
    
    // MARK: Grid
    
    func update(showGrid value: Bool) {
        
        showGrid = value
    }
    
    // MARK: Lattice
    
    var lattice: Double {
        
        camera.lattice
    }
    
    // MARK: Zoom Level
    
    var zoomLevel: ZoomLevel {
        
        camera.zoomLevel
    }
    
    func update(zoomLevel value: ZoomLevel) {
        
        camera.zoomLevel = value
    }
}
