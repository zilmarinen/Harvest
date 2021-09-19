//
//  BuildingChunk2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Foundation
import Meadow
import SpriteKit

public class BuildingChunk2D: FootprintChunk2D<BuildingTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case buildingType = "t"
    }
    
    var buildingType: BuildingType = .bernina_z {
        
        didSet {
            
            if oldValue != buildingType {
                
                becomeDirty()
            }
        }
    }
    
    public override var footprint: Footprint {
        
        guard let model = map?.props.prop(building: buildingType) else { fatalError("Error loading prop model \(buildingType)") }
        
        return Footprint(coordinate: coordinate, rotation: direction, nodes: model.footprint.nodes)
    }
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        buildingType = try container.decode(BuildingType.self, forKey: .buildingType)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(buildingType, forKey: .buildingType)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        blendMode = .alpha
        color = buildingType.color.osColor
        
        let attribute = vector_float4(Float(buildingType.color.r),
                                      Float(buildingType.color.g),
                                      Float(buildingType.color.b),
                                      Float(buildingType.color.a))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        return true
    }
}
