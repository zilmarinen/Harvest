//
//  StairChunk2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class StairChunk2D: FootprintChunk2D<StairTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case material = "m"
    }
    
    public var tileType: StairType = .sloped_1x1 {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    public var material: StairMaterial = .stone {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty()
            }
        }
    }
    
    public override var footprint: Footprint {
        
        guard let model = map?.props.prop(stairs: tileType, material: material) else { fatalError("Missing prop model") }
        
        return Footprint(coordinate: coordinate, rotation: direction, nodes: model.footprint.nodes)
    }
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(StairType.self, forKey: .tileType)
        material = try container.decode(StairMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(material, forKey: .material)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean(),
              let map = map else { return false }
        
        let tilemap = map.buildings.tilemap
        
        blendMode = .alpha
        color = material.color.color
        shader = tilemap.shader
        
        let attribute = vector_float4(Float(material.color.red),
                                      Float(material.color.green),
                                      Float(material.color.blue),
                                      Float(material.color.alpha))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        return true
    }
}
