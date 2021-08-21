//
//  Foliage2D.swift
//
//  Created by Zack Brown on 14/03/2021.
//

import Meadow
import SpriteKit

public class Foliage2D: FootprintGrid2D<FoliageChunk2D, FoliageTile2D> {
    
    struct Tilemap {
        
        let shader = SKShader(shader: .grid)
        
        init() {
            
            shader.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        }
    }
    
    let tilemap = Tilemap()
    
    public func add(foliage foliageType: FoliageType, coordinate: Coordinate, rotation: Cardinal, configure: ChunkConfiguration? = nil) -> FoliageChunk2D? {
     
        guard let map = map else { return nil }
        
        let model = map.props.prop(foliage: foliageType)
        
        let footprint = Footprint(coordinate: coordinate, rotation: rotation, nodes: model.footprint.nodes)
        
        guard map.validate(footprint: footprint, grid: .foliage) else { return nil }
        
        return super.add(chunk: footprint) { foliage in
            
            foliage.foliageType = foliageType
            foliage.direction = rotation
            
            configure?(foliage)
        }
    }
}
