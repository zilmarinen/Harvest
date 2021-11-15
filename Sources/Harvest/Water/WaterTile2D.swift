//
//  WaterTile2D.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class WaterTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public var material: WaterMaterial = .water {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty()
            }
        }
    }
    
    lazy var label: SKLabelNode = {
        
        let node = SKLabelNode()
        
        node.fontSize = 7
        node.fontColor = .black
        node.blendMode = .replace
        node.verticalAlignmentMode = .center
        node.xScale = 0.1
        node.yScale = -0.1
        node.zPosition = 1
        
        return node
    }()
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
        
        addChild(label)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(WaterMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
        
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(material, forKey: .material)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard super.clean(),
              let map = map else { return false }
        
        blendMode = .alpha
        color = material.color.osColor
        shader = SKShader(shader: .surface)
        shader?.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        
        let attribute = vector_float4(Float(material.color.r),
                                      Float(material.color.g),
                                      Float(material.color.b),
                                      Float(material.color.a))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        switch map.water.overlay {
        
        case .none:
            
            label.isHidden = true
            
        case .elevation:
            
            label.text = "\(coordinate.y)"
            label.isHidden = false
        }
        
        return true
    }
}

extension WaterTile2D {
    
    typealias Sample = (elevation: GridPattern<Double>, material: GridPattern<WaterMaterial?>)
    
    func sample() -> Sample {
        
        var elevation = GridPattern<Double>(value: Double(coordinate.y))
        var material = GridPattern<WaterMaterial?>(value: nil)
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            elevation.set(value: Double(neighbour?.coordinate.y ?? coordinate.y) , cardinal: cardinal)
            
            material.set(value: neighbour?.material, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let neighbour = find(neighbour: ordinal)
            
            elevation.set(value: Double(neighbour?.coordinate.y ?? coordinate.y), ordinal: ordinal)
            
            material.set(value: neighbour?.material, ordinal: ordinal)
        }
        
        return (elevation, material)
    }
}

extension WaterTile2D {
    
    public static func == (lhs: WaterTile2D, rhs: WaterTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}

extension WaterTile2D {
    
    func render(position: Position, corners: [Position]) -> [Euclid.Polygon] {
        
        return []
    }
}
