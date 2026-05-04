//
//  EditorView.swift
//
//  Created by Zack Brown on 10/08/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

@MainActor
open class EditorView: ARView {
    
    internal var context: CIContext?
    
    internal let floorPlane = float4x4(simd_quatf(angle: 0.0,
                                                  axis: .init(.unitY)))
    
    internal let camera = Camera()
    internal let cursor = Cursor()
    
    internal let world = AnchorEntity(world: .zero)
    
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        registerComponents()
        registerSystems()
        
        environment.background = .color(.windowBackgroundColor)
        
//        renderCallbacks.prepareWithDevice = { [weak self] device in
//        
//            guard let self else { return }
//            
//            self.prepare(with: device)
//        }
//        
//        renderCallbacks.postProcess = { [weak self] context in
//            
//            guard let self else { return }
//            
//            self.postProcess(context)
//        }
        
        scene.addAnchor(world)
        
        world.addChild(camera)
        world.addChild(cursor)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 
    open func registerComponents() {
        
        CameraComponent.registerComponent()
        CursorComponent.registerComponent()
    }
    
    open func registerSystems() {
        
        CameraSystem.registerSystem()
        CursorSystem.registerSystem()
    }
    
//    https://stackoverflow.com/questions/42912899/interior-like-edge-detection-using-ciimage
//    https://stackoverflow.com/questions/79802422/realitykit-how-to-support-post-process-with-custom-camera
//    private func prepare(with device: MTLDevice) {
//        
//        print("PREPARING")
//        
//        self.context = .init(mtlDevice: device)
//    }
//    
//    private func postProcess(_ context: ARView.PostProcessContext) {
//        
//        print("PROCESSING")
//        guard let sourceColor = CIImage(mtlTexture: context.sourceColorTexture) else { return }
//        
//        let filter = CIFilter.cannyEdgeDetector()
//        
//        filter.inputImage = sourceColor
//        
//        let destination = CIRenderDestination(mtlTexture: context.targetColorTexture,
//                                              commandBuffer: context.commandBuffer)
//        
//        destination.isFlipped = false
//        
//        guard let cntx = self.context,
//              let output = filter.outputImage else { return }
//        
//        do {
//            
//            _ = try cntx.startTask(toRender: output,
//                                   to: destination)
//        }
//        catch {
//            
//            fatalError("Error post processing frame: \(error.localizedDescription)")
//        }
//    }
}

// MARK: Hit Test

extension EditorView {
    
    public func hitTest(point: CGPoint) -> HitTest? {
        
        guard let ray = unproject(point,
                                  ontoPlane: floorPlane) else { return nil }
        
        let nearest = hitTest(point,
                              query: .all,
                              mask: .all)
        
        let pointInWorld = Vector(nearest.first?.position ?? ray)
        
        let triangle = Triangle(pointInWorld,
                                .tile)
        
        let closest = triangle.closest(pointInWorld,
                                       .tile)
        
        return .init(pointInWorld: pointInWorld,
                     triangle: triangle,
                     vertex: closest)
    }
}

// MARK: Camera

extension EditorView {
    
    public func camera(focus value: Vector) {
        
        camera.focus(on: value)
    }
    
    public func camera(rotate value: Hexagon.Rotation) {
        
        camera.rotate(value)
    }
    
    public func camera(translate value: Vector) {
        
        camera.translate(by: value.normalized())
    }
    
    public func camera(zoom value: Double) {
        
        camera.zoom(delta: value)
    }
}

// MARK: Cursor

extension EditorView {
    
    public func cursor(focus value: Vector) {
        
        cursor.focus(on: value)
    }
    
    public func cursor(rotate value: Triangle.Rotation) {
        
        cursor.rotate(value)
    }
    
    public func cursor(toggle style: CursorStyle) {
        
        cursor.toggle(style: style)
    }
    
    public var cursorRotation: Triangle.Rotation {
        
        cursor.rotation
    }
}
