//
//  RegionView.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import AppKit
import Deltille
import RealityKit

public class RegionView: EditorView {
    
    public let terrain = Terrain()
        
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        world.addChild(terrain)
    }
    
    public override func registerComponents() {
        
        super.registerComponents()
        
        HeightMapChunkComponent.registerComponent()
        TerrainComponent.registerComponent()
    }
    
    public override func registerSystems() {
        
        super.registerSystems()
        
        TerrainSystem.registerSystem()
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
        
        for chunk in region.heightMap {
            
            guard terrain.heightMap.chunk(for: chunk.hexagon) == nil else { continue }
            
            terrain.heightMap.addChild(chunk)
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
    
    private func save(region: TerrainRegion) -> Region? {
        
        guard !region.isEmpty else { return nil }
        
        let triangle = region.triangle
        
        return .init(coordinate: triangle.vertex.position,
                     identifier: region.name,
                     region: region,
                     heightMap: terrain.heightMap.chunks(intersecting: triangle))
    }
}
