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
        
        scene.addAnchor(world)
        
        world.addChild(camera)
        world.addChild(cursor)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 
    open func registerComponents() {
        
        CameraFocusComponent.registerComponent()
        CursorComponent.registerComponent()
    }
    
    open func registerSystems() {
        
        CameraSystem.registerSystem()
        CursorSystem.registerSystem()
    }
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
    
    public func set(camera focus: Vector) {
        
        // TODO: add has camera component protocol
        camera.focus(on: focus)
    }
    
    public func set(zoom value: Float) {
        
        // TODO: add has camera component protocol
        camera.zoom(delta: value)
    }
}

// MARK: Cursor

extension EditorView {
    
    public func set(cursor focus: Vector) {
        
        cursor.set(focus: focus)
    }
    
    public func set(cursor cursorStyle: CursorStyle) {
        
        cursor.set(cursorStyle: cursorStyle)
    }
}
