//
//  BuildingChunk2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Foundation
import Meadow
import SpriteKit

public class BuildingChunk2D: PropChunk2D<BuildingTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case architecture = "a"
        case polyomino = "p"
    }
    
    public override var footprint: Footprint { Footprint(coordinate: coordinate, rotation: direction, nodes: polyomino.footprint.nodes) }
    
    public var architecture: BuildingArchitecture = .bernina {
        
        didSet {
            
            if oldValue != architecture {
                
                becomeDirty()
            }
        }
    }
    
    public var polyomino: Polyomino = .z {
        
        didSet {
            
            if oldValue != polyomino {
                
                becomeDirty()
            }
        }
    }
    
    required init(coordinate: Coordinate, direction: Cardinal) {
        
        super.init(coordinate: coordinate, direction: direction)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        architecture = try container.decode(BuildingArchitecture.self, forKey: .architecture)
        polyomino = try container.decode(Polyomino.self, forKey: .polyomino)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(architecture, forKey: .architecture)
        try container.encode(polyomino, forKey: .polyomino)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        blendMode = .alpha
        color = architecture.color.osColor
        
        let attribute = vector_float4(Float(architecture.color.r),
                                      Float(architecture.color.g),
                                      Float(architecture.color.b),
                                      Float(architecture.color.a))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        return true
    }
}
