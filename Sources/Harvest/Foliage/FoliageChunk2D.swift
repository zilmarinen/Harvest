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
    
    public var foliageType: FoliageType = .spruce {
        
        didSet {
            
            if oldValue != foliageType {
                
                becomeDirty()
            }
        }
    }
    
    public override var footprint: Footprint {
        
        guard let model = map?.props.prop(foliage: foliageType) else { fatalError("Error loading prop model \(foliageType)") }
        
        return Footprint(coordinate: coordinate, rotation: direction, nodes: model.footprint.nodes)
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
              let map = map else { return false }
        
        let tilemap = map.foliage.tilemap
        
        let attribute = vector_float4(Float(foliageType.color.r),
                                      Float(foliageType.color.g),
                                      Float(foliageType.color.b),
                                      Float(foliageType.color.a))
        
        for tile in tiles {
            
            tile.color = foliageType.color.osColor
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
