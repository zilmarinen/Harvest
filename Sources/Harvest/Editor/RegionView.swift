//
//  RegionView.swift
//
//  Created by Zack Brown on 04/09/2025.
//

import AppKit
import Deltille
import Lattice
import RealityKit

public class RegionView: EditorView {
    
    internal let biosphere = Biosphere()
    internal let foliage = Foliage()
    internal let terrain = Terrain()
    internal let water = Water()
        
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        world.addChild(biosphere)
        world.addChild(foliage)
        world.addChild(terrain)
        world.addChild(water)
    }
    
    public override func registerComponents() {
        
        super.registerComponents()
        
        BiomeComponent.registerComponent()
        FoliageComponent.registerComponent()
        WaterComponent.registerComponent()
    }
    
    public override func registerSystems() {
        
        super.registerSystems()
        
        FoliageSystem.registerSystem()
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
        
        region.terrain.name = region.identifier
        
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
                     identifier: terrain.name,
                     biomes: biosphere.chunks(intersecting: triangle),
                     foliage: foliage.region(for: triangle),
                     terrain: terrain,
                     water: water.region(for: triangle))
    }
}

// MARK: Biome

extension RegionView {
    
    public func get(biome vertex: Triangle.Vertex) -> BiomeVertex? {
        
        biosphere.get(biome: vertex)
    }
    
    public func set(_ biome: Biome,
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
    
    public func set(_ biome: Biome,
                    _ elevation: Int,
                    for vertex: Triangle.Vertex) {
        
        biosphere.set(biome,
                      elevation,
                      for: vertex)
        
        terrain.terraform(vertex: vertex)
    }
}

// MARK: Foliage

extension RegionView {
    
    public func set(foliage triangle: Triangle) {
        
        foliage.set(foliage: triangle)
    }
}

// MARK: Water

extension RegionView {
    
    public func get(water triangle: Triangle) -> WaterTile? {
        
        water.get(tile: triangle)
    }
    
    public func set(_ waterType: WaterType,
                    _ elevation: Int,
                    for triangle: Triangle) {
        
        water.set(waterType,
                  elevation,
                  for: triangle)
    }
}
