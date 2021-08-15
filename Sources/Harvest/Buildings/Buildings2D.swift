//
//  Buildings2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Meadow
import SpriteKit

public class Buildings2D: FootprintGrid2D<BuildingChunk2D, BuildingTile2D> {
    
    struct Tilemap {
        
        let shader = SKShader(shader: .building)
        
        init() {
            
            shader.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        }
    }
    
    let tilemap = Tilemap()
    
    public func add(building coordinate: Coordinate, rotation: Cardinal, buildingType: BuildingType, configure: ChunkConfiguration? = nil) -> BuildingChunk2D? {
        
        guard let harvest = harvest else { return nil }
        
        let model = harvest.props.prop(prop: buildingType)
        
        let footprint = Footprint(coordinate: coordinate, rotation: rotation, nodes: model.footprint.nodes)
        
        guard harvest.validate(footprint: footprint, grid: .buildings) else { return nil }
        
        guard let building = super.add(chunk: footprint) else { return nil }
        
        building.buildingType = buildingType
        building.direction = rotation
        
        configure?(building)
        
        return building
    }
}
