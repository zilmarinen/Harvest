//
//  EditorView.swift
//
//  Created by Zack Brown on 10/08/2025.
//

import AppKit
import Bivouac
import Cobble
import Deltille
import Euclid
import Lattice
import Newel
import Palisade
import RealityKit

@MainActor
open class EditorView: ARView {
    
    internal var context: CIContext?
    
    internal let floorPlane = float4x4(simd_quatf(angle: 0.0,
                                                  axis: .init(.unitY)))
    
    internal let camera = OrthographicCamera()
    internal let cursor = Cursor()
    
    internal let buildings = Buildings()
    internal let fences = Fences()
    internal let foliage = Foliage()
    internal let footpaths = Footpaths()
    internal let portals = Portals()
    internal let slopes = Slopes()
    internal let terrain = Terrain()
    internal let water = Water()
    
    internal let world = AnchorEntity(world: .zero)
    
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        environment.background = .color(.windowBackgroundColor)
        
        renderCallbacks.prepareWithDevice = { [weak self] device in
        
            guard let self else { return }
            
            self.prepare(with: device)
        }
        
        renderCallbacks.postProcess = { [weak self] context in
            
            guard let self else { return }
            
            self.postProcess(context)
        }
        
        world.name = AnchorEntity.Identifier.world.id
        
        scene.addAnchor(world)
        
        world.addChild(camera)
        world.addChild(cursor)
        
        world.addChild(buildings)
        world.addChild(fences)
        world.addChild(foliage)
        world.addChild(footpaths)
        world.addChild(portals)
        world.addChild(slopes)
        world.addChild(terrain)
        world.addChild(water)
        
        registerComponents()
        registerSystems()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 
    open func registerComponents() {
        
        CursorComponent.registerComponent()
        
        DataStoreComponent<Triangle.Vertex, WaterTile>.registerComponent()
        DataStoreComponent<Triangle.Vertex, TerrainVertex>.registerComponent()
    }
    
    open func registerSystems() {
        
        CameraSystem.registerSystem()
        CursorSystem.registerSystem()
        
        BuildingSystem.registerSystem()
        FenceSystem.registerSystem()
        FoliageSystem.registerSystem()
        FootpathSystem.registerSystem()
        PortalSystem.registerSystem()
        SlopeSystem.registerSystem()
        TerrainSystem.registerSystem()
        WaterSystem.registerSystem()
    }
    
//    https://stackoverflow.com/questions/42912899/interior-like-edge-detection-using-ciimage
//    https://stackoverflow.com/questions/79802422/realitykit-how-to-support-post-process-with-custom-camera
    private func prepare(with device: MTLDevice) {
        
        self.context = .init(mtlDevice: device)
    }
    
    private func postProcess(_ context: ARView.PostProcessContext) {
        
        guard let sourceColor = CIImage(mtlTexture: context.sourceColorTexture) else { return }
        
        let edgeFilter = CIFilter.cannyEdgeDetector()
        
        edgeFilter.gaussianSigma = 1.4
        edgeFilter.perceptual = false
        edgeFilter.thresholdLow = 0.02
        edgeFilter.thresholdHigh = 0.05
        edgeFilter.hysteresisPasses = 2
        edgeFilter.inputImage = sourceColor
        
        let blendFilter = CIFilter.blendWithMask()
        
        blendFilter.backgroundImage = sourceColor
        blendFilter.maskImage = edgeFilter.outputImage
        blendFilter.inputImage = .black
        
        let destination = CIRenderDestination(mtlTexture: context.targetColorTexture,
                                              commandBuffer: context.commandBuffer)
        
        destination.isFlipped = false
        
        guard let cntx = self.context,
              let output = blendFilter.outputImage else { return }
        
        do {
            
            _ = try cntx.startTask(toRender: output,
                                   to: destination)
        }
        catch {
            
            fatalError("Error post processing frame: \(error.localizedDescription)")
        }
    }
}

// MARK: Loading

extension EditorView {
    
    public func load(regions: [Region]) {
        
        for region in regions {
            
            load(region: region)
        }
    }
    
    private func load(region: Region) {
        
        if let slice = region.buildings { buildings.merge(slice) }
        if let slice = region.fences { fences.merge(slice) }
        if let slice = region.foliage { foliage.merge(slice) }
        if let slice = region.footpaths { footpaths.merge(slice) }
        if let slice = region.portals { portals.merge(slice) }
        if let slice = region.slopes { slopes.merge(slice) }
        if let slice = region.terrain { terrain.merge(slice) }
        if let slice = region.water { water.merge(slice) }
    }
}

// MARK: Saving

extension EditorView {
    
    public func save(regions: [Triangle]) -> [Region] {
        
        regions.map {
            
            save(region: $0)
        }
    }
    
    private func save(region triangle: Triangle) -> Region {
        
        let terrain = terrain.slice(region: triangle)
        
        return .init(vertex: triangle.vertex,
                     buildings: buildings.slice(region: triangle),
                     fences: fences.slice(region: triangle),
                     foliage: foliage.slice(region: triangle),
                     footpaths: footpaths.slice(region: triangle),
                     portals: portals.slice(region: triangle),
                     slopes: slopes.slice(region: triangle),
                     terrain: terrain,
                     water: water.slice(region: triangle))
    }
}

// MARK: Hit Test

extension EditorView {
    
    public func hit(_ point: CGPoint) -> Vector? {
        
        guard let ray = unproject(point,
                                  ontoPlane: floorPlane,
                                  relativeToCamera: false) else { return nil }
        
        let nearest = hitTest(point,
                              query: .nearest,
                              mask: .all)
        
        return .init(nearest.first?.position ?? ray)
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

// MARK: Buildings

extension EditorView {
    
    public func set(_ septomino: Triangle.Septomino,
                    for triangle: Triangle) {
        
        let value = BuildingTile(vertex: triangle.vertex,
                                 rotation: cursorRotation,
                                 septomino: septomino)
        
        buildings.set(value,
                      for: triangle)
        
        terrain.propagate([triangle.vertex])
    }
    
    public func remove(building triangle: Triangle) {
        
        buildings.remove(values: [triangle])
        
        terrain.propagate([triangle.vertex])
    }
}

// MARK: Fences

extension EditorView {
    
    public func set(_ rampart: Rampart,
                    _ segment: FenceSegment,
                    for vertex: Triangle.Vertex) {
        
        fences.set(.init(vertex: vertex,
                         rampart: rampart,
                         segment: segment),
                      for: vertex)
    }
    
    public func remove(fence vertex: Triangle.Vertex) {
        
        fences.remove(values: [vertex])
    }
}

// MARK: Foliage

extension EditorView {
    
    public func set(foliage vertex: Triangle.Vertex) {
        
        foliage.set(.init(vertex: vertex,
                          foliageType: .fornax),
                    for: vertex)
    }
    
    public func remove(foliage vertex: Triangle.Vertex) {
        
        foliage.remove(values: [vertex])
    }
}

// MARK: Footpaths

extension EditorView {
    
    public func set(_ design: Design,
                    for vertex: Triangle.Vertex) {
        
        footpaths.set(.init(vertex: vertex,
                            design: design),
                      for: vertex)
    }
    
    public func remove(footpath vertex: Triangle.Vertex) {
        
        footpaths.remove(values: [vertex])
    }
}

// MARK: Portals

extension EditorView {
    
    public func add(portal triangle: Triangle) {
        
        portals.set(.init(vertex: triangle.vertex,
                          rotation: cursorRotation),
                    for: triangle)
    }
    
    public func remove(portal triangle: Triangle) {
        
        portals.remove(values: [triangle])
    }
}

// MARK: Slopes

extension EditorView {
    
    public func set(_ slope: Slope,
                    _ rise: Rise,
                    _ cast: Cast,
                    for triangle: Triangle) {
        
        let value = SlopeTile(vertex: triangle.vertex,
                              rotation: cursorRotation,
                              slope: slope,
                              rise: rise,
                              cast: cast)
        
        slopes.set(value,
                   for: triangle)
        
        terrain.propagate([triangle.vertex])
    }
    
    public func remove(slope triangle: Triangle) {
        
        slopes.remove(values: [triangle])
        
        terrain.propagate([triangle.vertex])
    }
}

// MARK: Terrain

extension EditorView {
    
    public func get(biome vertex: Triangle.Vertex) -> TerrainVertex? {
        
        terrain.value(for: vertex)
    }
    
    public func set(_ biome: Biome?,
                    for vertex: Triangle.Vertex) {
        
        guard let existing = get(biome: vertex) else { return }
        
        set(biome,
            existing.elevation,
            for: vertex)
    }
    
    public func set(_ elevation: Int,
                    for vertex: Triangle.Vertex) {
        
        guard let existing = get(biome: vertex) else { return }
        
        set(existing.biome,
            elevation,
            for: vertex)
    }
    
    public func set(_ biome: Biome?,
                    _ elevation: Int,
                    for vertex: Triangle.Vertex) {
        
        if let biome {
            
            terrain.set(.init(vertex: vertex,
                              biome: biome,
                              elevation: elevation),
                        for: vertex)
            
        } else {
            
            terrain.remove(values: [vertex])
        }
        
        fences.propagate([vertex])
        foliage.propagate([vertex])
        footpaths.propagate([vertex])
        slopes.propagate(vertex.tiles)
        water.propagate(vertex.tiles)
    }
}

// MARK: Water

extension EditorView {
    
    public func get(water triangle: Triangle) -> WaterTile? {
        
        water.value(for: triangle)
    }
    
    public func set(_ waterType: WaterType,
                    _ elevation: Int,
                    for triangle: Triangle) {
        
        guard elevation > 0 else {
            
            return remove(water: triangle)
        }
        
        water.set(.init(vertex: triangle.vertex,
                        rotation: .identity,
                        waterType: waterType,
                        elevation: elevation),
                  for: triangle)
    }
    
    public func remove(water triangle: Triangle) {
        
        water.remove(values: [triangle])
    }
}
