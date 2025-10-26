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
        FoliageAssetCacheComponent.registerComponent()
        TerrainAssetCacheComponent.registerComponent()
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
        
        region.region.name = region.identifier
        
        terrain.addChild(region.region)
        biosphere.merge(region.biomes)
    }
}

// MARK: Saving

extension RegionView {
    
    public func save() -> [Region] {
        
        terrain.regions.compactMap {
            
            save(region: $0)
        }
    }
    
    private func save(region: TerrainRegion) -> Region? {
        
        guard !region.isEmpty else { return nil }
        
        let triangle = region.triangle
        
        return .init(coordinate: triangle.vertex.position,
                     identifier: region.name,
                     region: region,
                     biomes: biosphere.chunks(intersecting: triangle))
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
    
    public func set(_ waterType: WaterType,
                    _ elevation: Int,
                    for triangle: Triangle) {
        
        water.set(waterType,
                  elevation,
                  for: triangle)
    }
}
