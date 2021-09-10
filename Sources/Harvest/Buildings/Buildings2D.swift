//
//  Buildings2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Meadow
import SpriteKit

public class Buildings2D: FootprintGrid2D<BuildingChunk2D, BuildingTile2D> {
    
    public func add(building coordinate: Coordinate, rotation: Cardinal, buildingType: BuildingType, configure: ChunkConfiguration? = nil) -> BuildingChunk2D? {
        
        guard let map = map else { return nil }
        
        let model = map.props.prop(building: buildingType)
        
        let footprint = Footprint(coordinate: coordinate, rotation: rotation, nodes: model.footprint.nodes)
        
        guard map.validate(footprint: footprint, grid: .buildings) else { return nil }
        
        guard let building = super.add(chunk: footprint) else { return nil }
        
        building.buildingType = buildingType
        building.direction = rotation
        
        configure?(building)
        
        return building
    }
}
