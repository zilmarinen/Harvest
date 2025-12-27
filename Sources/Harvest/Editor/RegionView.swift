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
    
    internal let edifices = Edifices()
    internal let foliage = Foliage()
    internal let footpaths = Footpaths()
    internal let stairs = Stairs()
    internal let terrain = Terrain()
    internal let water = Water()
        
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        world.addChild(edifices)
        world.addChild(foliage)
        world.addChild(footpaths)
        world.addChild(stairs)
        world.addChild(terrain)
        world.addChild(water)
    }
    
    public override func registerComponents() {
        
        super.registerComponents()
        
        DataSource<Triangle, WaterTile>.registerComponent()
        DataSource<Triangle.Vertex, TerrainVertex>.registerComponent()
    }
    
    public override func registerSystems() {
        
        super.registerSystems()
        
        EdificeSystem.registerSystem()
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
        
        if let slice = region.terrain {
            
            slice.grid?.name = region.identifier
            
            terrain.merge(slice)
        }
        
        if let slice = region.edifices { edifices.merge(slice) }
        if let slice = region.foliage { foliage.merge(slice) }
        if let slice = region.footpaths { footpaths.merge(slice) }
        if let slice = region.stairs { stairs.merge(slice) }
        if let slice = region.water { water.merge(slice) }
    }
}

// MARK: Saving

extension RegionView {
    
    public func save(regions triangle: Triangle) -> [Region] {
        
        let regions = [triangle] + triangle.perimeter
        
        return regions.map {
            
            save(region: $0)
        }
    }
    
    private func save(region triangle: Triangle) -> Region {
        
        let terrain = terrain.slice(region: triangle)
        
        return .init(triangle: triangle,
                     identifier: terrain?.grid?.name ?? triangle.id,
                     edifices: edifices.slice(region: triangle),
                     foliage: foliage.slice(region: triangle),
                     footpaths: footpaths.slice(region: triangle),
                     stairs: stairs.slice(region: triangle),
                     terrain: terrain,
                     water: water.slice(region: triangle))
    }
}

// MARK: Edifices

extension RegionView {
    
    public func set(_ septomino: Triangle.Septomino,
                    for triangle: Triangle) {
        
        let value = EdificeFootprint(origin: triangle,
                                     septomino: septomino)
        
        edifices.set(value,
                     for: triangle)
        
        for tile in value.footprint.tiles {
         
            terrain.propagate(triangle: tile)
        }
    }
    
    public func remove(edifice triangle: Triangle) {
        
        guard let existing = edifices.value(for: triangle) else { return }
        
        edifices.set(nil,
                     for: triangle)
        
        for tile in existing.footprint.tiles {
            
            terrain.propagate(triangle: tile)
        }
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
        
        let value = StairFootprint(origin: triangle,
                                   stoop: stoop)
        
        stairs.set(value,
                   for: triangle)
        
        for tile in value.footprint.tiles {
         
            terrain.propagate(triangle: tile)
        }
    }
    
    public func remove(staircase triangle: Triangle) {
        
        guard let existing = stairs.value(for: triangle) else { return }
        
        stairs.set(nil,
                   for: triangle)
        
        for tile in existing.footprint.tiles {
            
            terrain.propagate(triangle: tile)
        }
    }
}

// MARK: Terrain

extension RegionView {
    
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
            
            terrain.set(nil,
                        for: vertex)
        }
        
        foliage.propagate(vertex: vertex)
        footpaths.propagate(vertex: vertex)
        stairs.propagate(vertex: vertex)
        water.propagate(vertex: vertex)
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
        
        guard elevation > 0 else {
            
            return water.set(nil,
                             for: triangle)
        }
        
        water.set(.init(triangle: triangle,
                        waterType: waterType,
                        elevation: elevation),
                  for: triangle)
    }
}
