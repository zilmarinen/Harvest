//
//  RegionView.swift
//
//  Created by Zack Brown on 04/09/2025.
//

import AppKit
import Bivouac
import Deltille
import Lattice
import Newel
import RealityKit

public class RegionView: EditorView {
    
    internal let buildings = Buildings()
    internal let foliage = Foliage()
    internal let footpaths = Footpaths()
    internal let portals = Portals()
    internal let slopes = Slopes()
    internal let terrain = Terrain()
    internal let water = Water()
        
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        world.addChild(buildings)
        world.addChild(foliage)
        world.addChild(footpaths)
        world.addChild(portals)
        world.addChild(slopes)
        world.addChild(terrain)
        world.addChild(water)
        
        camera.addChild(WorldFloorPlane())
    }
    
    public override func registerComponents() {
        
        super.registerComponents()
        
        DataStoreComponent<Triangle.Vertex, WaterTile>.registerComponent()
        DataStoreComponent<Triangle.Vertex, TerrainVertex>.registerComponent()
    }
    
    public override func registerSystems() {
        
        super.registerSystems()
        
        BuildingSystem.registerSystem()
        FoliageSystem.registerSystem()
        FootpathSystem.registerSystem()
        PortalSystem.registerSystem()
        SlopeSystem.registerSystem()
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
            
            slice.region.name = region.identifier
            
            terrain.merge(slice)
        }
        
        if let slice = region.buildings { buildings.merge(slice) }
        if let slice = region.foliage { foliage.merge(slice) }
        if let slice = region.footpaths { footpaths.merge(slice) }
        if let slice = region.portals { portals.merge(slice) }
        if let slice = region.slopes { slopes.merge(slice) }
        if let slice = region.water { water.merge(slice) }
    }
}

// MARK: Saving

extension RegionView {
    
    public func save(regions: [Triangle]) -> [Region] {
        
        return regions.map {
            
            save(region: $0)
        }
    }
    
    private func save(region triangle: Triangle) -> Region {
        
        let terrain = terrain.slice(region: triangle)
        
        return .init(origin: triangle.vertex,
                     identifier: terrain?.region.name ?? triangle.id,
                     buildings: buildings.slice(region: triangle),
                     foliage: foliage.slice(region: triangle),
                     footpaths: footpaths.slice(region: triangle),
                     portals: portals.slice(region: triangle),
                     slopes: slopes.slice(region: triangle),
                     terrain: terrain,
                     water: water.slice(region: triangle))
    }
}

// MARK: Buildings

extension RegionView {
    
    public func set(_ septomino: Triangle.Septomino,
                    for triangle: Triangle) {
        
        let value = BuildingTile(origin: triangle.vertex,
                                 rotation: cursorRotation,
                                 septomino: septomino)
        
        buildings.set(value,
                      for: triangle.vertex)
        
        for tile in value.footprint.tiles {
         
            terrain.propagate(triangle: tile)
        }
    }
    
    public func remove(building triangle: Triangle) {
        
        guard let existing = buildings.value(for: triangle.vertex) else { return }
        
        buildings.set(nil,
                      for: triangle.vertex)
        
        for tile in existing.footprint.tiles {
            
            terrain.propagate(triangle: tile)
        }
    }
}

// MARK: Foliage

extension RegionView {
    
    public func set(foliage triangle: Triangle) {
        
        foliage.set(.init(origin: triangle.vertex,
                          rotation: cursorRotation,
                          foliageType: .fornax),
                    for: triangle.vertex)
    }
    
    public func remove(foliage triangle: Triangle) {
        
        foliage.set(nil,
                    for: triangle.vertex)
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
        
        portals.set(.init(origin: triangle.vertex,
                          rotation: cursorRotation),
                    for: triangle.vertex)
    }
    
    public func remove(portal triangle: Triangle) {
        
        portals.set(nil,
                    for: triangle.vertex)
    }
}

// MARK: Slopes

extension RegionView {
    
    public func set(_ slope: Slope,
                    _ rise: Rise,
                    _ cast: Cast,
                    for triangle: Triangle) {
        
        let value = SlopeTile(origin: triangle.vertex,
                              rotation: cursorRotation,
                              slope: slope,
                              rise: rise,
                              cast: cast)
        
        slopes.set(value,
                   for: triangle.vertex)
        
        for tile in value.footprint.tiles {
         
            terrain.propagate(triangle: tile)
        }
    }
    
    public func remove(slope triangle: Triangle) {
        
        guard let existing = slopes.value(for: triangle.vertex) else { return }
        
        slopes.set(nil,
                   for: triangle.vertex)
        
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
            
            terrain.remove(values: [vertex])
        }
        
        foliage.propagate(vertex: vertex)
        footpaths.propagate(vertex: vertex)
        slopes.propagate(vertex: vertex)
        water.propagate(vertex: vertex)
    }
}

// MARK: Water

extension RegionView {
    
    public func get(water triangle: Triangle) -> WaterTile? {
        
        water.value(for: triangle.vertex)
    }
    
    public func set(_ waterType: WaterType,
                    _ elevation: Int,
                    for triangle: Triangle) {
        
        guard elevation > 0 else {
            
            return remove(water: triangle)
        }
        
        water.set(.init(origin: triangle.vertex,
                        waterType: waterType,
                        elevation: elevation),
                  for: triangle.vertex)
    }
    
    public func remove(water triangle: Triangle) {
        
        water.remove(values: [triangle.vertex])
    }
}
