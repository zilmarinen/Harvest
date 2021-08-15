//
//  FoliageChunk2D.swift
//
//  Created by Zack Brown on 14/03/2021.
//

import Foundation
import Meadow
import SpriteKit

public class FoliageChunk2D: FootprintChunk2D<FoliageTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case foliageType = "t"
    }
    
    public var foliageType: FoliageType = .treeSmall {
        
        didSet {
            
            if oldValue != foliageType {
                
                becomeDirty()
            }
        }
    }
    
    public override var footprint: Footprint {
        
        guard let model = harvest?.props.prop(prop: foliageType) else { fatalError("Missing prop model") }
        
        return Footprint(coordinate: coordinate, rotation: .north, nodes: model.footprint.nodes)
    }
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foliageType = try container.decode(FoliageType.self, forKey: .foliageType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(foliageType, forKey: .foliageType)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean(),
              let harvest = harvest else { return false }
        
        let tilemap = harvest.foliage.tilemap
        
        let attribute = vector_float4(Float(foliageType.color.red),
                                      Float(foliageType.color.green),
                                      Float(foliageType.color.blue),
                                      Float(foliageType.color.alpha))
        
        for tile in tiles {
            
            tile.color = foliageType.color.color
            tile.shader = tilemap.shader
            tile.setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
            
            _ = tile.clean()
        }
        
        return true
    }
}

extension FoliageChunk2D {
    
    public static func == (lhs: FoliageChunk2D, rhs: FoliageChunk2D) -> Bool {
        
        return lhs.footprint == rhs.footprint && lhs.foliageType == rhs.foliageType
    }
}
