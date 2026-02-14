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
    
    internal let buildings = Buildings()
    internal let foliage = Foliage()
    internal let footpaths = Footpaths()
    internal let portals = Portals()
    internal let staircases = Staircases()
    internal let terrain = Terrain()
    internal let water = Water()
        
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        world.addChild(buildings)
        world.addChild(foliage)
        world.addChild(footpaths)
        world.addChild(portals)
        world.addChild(staircases)
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
        
        BuildingSystem.registerSystem()
        FoliageSystem.registerSystem()
        FootpathSystem.registerSystem()
        PortalSystem.registerSystem()
        StaircaseSystem.registerSystem()
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
        
        if let slice = region.buildings { buildings.merge(slice) }
        if let slice = region.foliage { foliage.merge(slice) }
        if let slice = region.footpaths { footpaths.merge(slice) }
        if let slice = region.portals { portals.merge(slice) }
        if let slice = region.staircases { staircases.merge(slice) }
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
                     buildings: buildings.slice(region: triangle),
                     foliage: foliage.slice(region: triangle),
                     footpaths: footpaths.slice(region: triangle),
                     portals: portals.slice(region: triangle),
                     staircases: staircases.slice(region: triangle),
                     terrain: terrain,
                     water: water.slice(region: triangle))
    }
}

// MARK: Buildings

extension RegionView {
    
    public func set(_ septomino: Triangle.Septomino,
                    for triangle: Triangle) {
        
        let value = BuildingFootprint(origin: triangle,
                                      septomino: septomino)
        
        buildings.set(value,
                      for: triangle)
        
        for tile in value.footprint.tiles {
         
            terrain.propagate(triangle: tile)
        }
    }
    
    public func remove(building triangle: Triangle) {
        
        guard let existing = buildings.value(for: triangle) else { return }
        
        buildings.set(nil,
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

// MARK: Portals

extension RegionView {
    
    public func add(portal triangle: Triangle) {
        
        portals.set(.init(triangle: triangle),
                    for: triangle)
    }
    
    public func remove(portal triangle: Triangle) {
        
        portals.set(nil,
                    for: triangle)
    }
}

// MARK: Staircases

extension RegionView {
    
    public func set(_ staircaseType: StaircaseType,
                    for triangle: Triangle) {
        
        let value = StaircaseFootprint(origin: triangle,
                                       staircaseType: staircaseType)
        
        staircases.set(value,
                       for: triangle)
        
        for tile in value.footprint.tiles {
         
            terrain.propagate(triangle: tile)
        }
    }
    
    public func remove(staircase triangle: Triangle) {
        
        guard let existing = staircases.value(for: triangle) else { return }
        
        staircases.set(nil,
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
        staircases.propagate(vertex: vertex)
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
