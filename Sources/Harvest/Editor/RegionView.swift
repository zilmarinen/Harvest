//
//  RegionView.swift
//
//  Created by Zack Brown on 04/09/2025.
//

import AppKit
import Deltille
import Lattice
import Newel
import RealityKit

public class RegionView: EditorView {
    
    internal let biosphere = Biosphere()
    internal let edifices = Edifices()
    internal let foliage = Foliage()
    internal let footpaths = Footpaths()
    internal let stairs = Stairs()
    internal let terrain = Terrain()
    internal let water = Water()
        
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        world.addChild(biosphere)
        world.addChild(edifices)
        world.addChild(foliage)
        world.addChild(footpaths)
        world.addChild(stairs)
        world.addChild(terrain)
        world.addChild(water)
    }
    
    public override func registerComponents() {
        
        super.registerComponents()
        
        TileDataSource<Stoop>.registerComponent()
        TileDataSource<Triangle>.registerComponent()
        TileDataSource<Triangle.Septomino>.registerComponent()
        TileDataSource<WaterTile>.registerComponent()
        VertexDataSource<BiomeVertex>.registerComponent()
        VertexDataSource<FootpathType>.registerComponent()
        VertexDataSource<Triangle.Vertex>.registerComponent()
    }
    
    public override func registerSystems() {
        
        super.registerSystems()
        
        FoliageSystem.registerSystem()
        FootpathSystem.registerSystem()
        StairSystem.registerSystem()
        TerrainSystem.registerSystem()
        WaterSystem.registerSystem()
    }
}

// MARK: Loading

extension RegionView {
    
    public func load(regions: [Region]) {
        
        for region in regions {
            
            load(region: region)
        }
    }
    
    private func load(region: Region) {
        
        biosphere.merge(region.biomes)
        terrain.addChild(region.terrain)
        
        if let child = region.foliage {
            
            foliage.addChild(child)
        }
        
        if let child = region.water {
            
            water.addChild(child)
        }
    }
}

// MARK: Saving

extension RegionView {
    
    public func save() -> [Region] {
        
        terrain.regions.compactMap {
            
            save(region: $0)
        }
    }
    
    private func save(region terrain: TerrainRegion) -> Region? {
        
        guard !terrain.isEmpty else { return nil }
        
        let triangle = terrain.triangle
        
        return .init(coordinate: triangle.vertex.position,
                     biomes: biosphere.chunks(intersecting: triangle),
                     foliage: foliage.region(for: triangle,
                                             .region),
                     terrain: terrain,
                     water: water.region(for: triangle,
                                         .region))
    }
}

// MARK: Biome

extension RegionView {
    
    public func get(biome vertex: Triangle.Vertex) -> BiomeVertex? {
        
        biosphere.value(for: vertex)
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
            
            biosphere.set(.init(vertex: vertex,
                                biome: biome,
                                elevation: elevation),
                          for: vertex)
            
        } else {
            
            biosphere.set(nil,
                          for: vertex)
        }
        
        terrain.terraform(vertex: vertex)
        foliage.propagate(vertex: vertex)
    }
}

// MARK: Foliage

extension RegionView {
    
    public func set(foliage triangle: Triangle) {
        
        foliage.set(triangle,
                    for: triangle)
    }
    
    public func remove(foliage triangle: Triangle) {
        
        foliage.set(nil,
                    for: triangle)
    }
}

// MARK: Footpaths

extension RegionView {
    
    public func set(_ footpathType: FootpathType,
                    for vertex: Triangle.Vertex) {
        
        footpaths.set(footpathType,
                      for: vertex)
    }
    
    public func remove(footpath vertex: Triangle.Vertex) {
        
        footpaths.set(nil,
                      for: vertex)
    }
}

// MARK: Stairs

extension RegionView {
    
    public func set(_ stoop: Stoop,
                    for triangle: Triangle) {
        
        stairs.set(stoop,
                   for: triangle)
        
        triangle.vertices.forEach {
            
            terrain.terraform(vertex: $0)
        }
    }
    
    public func remove(staircase triangle: Triangle) {
        
        stairs.set(nil,
                   for: triangle)
        
        triangle.vertices.forEach {
            
            terrain.terraform(vertex: $0)
        }
    }
}

// MARK: Water

extension RegionView {
    
    public func get(water triangle: Triangle) -> WaterTile? {
        
        water.value(for: triangle)
    }
    
    public func set(_ waterType: WaterType,
                    _ elevation: Int,
                    for triangle: Triangle) {
        
        water.set(.init(triangle: triangle,
                        waterType: waterType,
                        elevation: elevation),
                  for: triangle)
    }
}
