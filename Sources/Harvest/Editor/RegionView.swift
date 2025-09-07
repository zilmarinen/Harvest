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
        
        HeightMapChunkDataComponent.registerComponent()
        TerrainComponent.registerComponent()
    }
    
    public override func registerSystems() {
        
        super.registerSystems()
        
        TerrainSystem.registerSystem()
    }
}
