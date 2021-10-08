//
//  StairChunk2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class StairChunk2D: PropChunk2D<StairTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case stairType = "t"
        case material = "m"
    }
    
    public var stairType: StairType = .sloped_1x1 {
        
        didSet {
            
            if oldValue != stairType {
                
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
    
    required init(coordinate: Coordinate, direction: Cardinal) {
        
        super.init(coordinate: coordinate, direction: direction)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        stairType = try container.decode(StairType.self, forKey: .stairType)
        material = try container.decode(StairMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(stairType, forKey: .stairType)
        try container.encode(material, forKey: .material)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        blendMode = .alpha
        color = material.color.osColor
        
        let attribute = vector_float4(Float(material.color.r),
                                      Float(material.color.g),
                                      Float(material.color.b),
                                      Float(material.color.a))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        return true
    }
}
