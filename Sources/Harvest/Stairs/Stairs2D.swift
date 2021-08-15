//
//  Stairs2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class Stairs2D: FootprintGrid2D<StairChunk2D, StairTile2D> {
    
    public func add(stairs coordinate: Coordinate, rotation: Cardinal, tileType: StairType, material: StairMaterial, configure: ChunkConfiguration? = nil) -> StairChunk2D? {
        
        guard let harvest = harvest else { return nil }
        
        let model = harvest.props.prop(stairs: tileType, material: material)
        
        let footprint = Footprint(coordinate: coordinate, rotation: rotation, nodes: model.footprint.nodes)
        
        guard harvest.validate(footprint: footprint, grid: .stairs) else { return nil }
        
        guard let stairs = super.add(chunk: footprint) else { return nil }
        
        stairs.tileType = tileType
        stairs.material = material
        stairs.direction = rotation
        
        configure?(stairs)
        
        return stairs
    }
}
