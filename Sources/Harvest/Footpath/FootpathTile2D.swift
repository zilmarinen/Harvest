//
//  FootpathTile2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class FootpathTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
        case pattern = "p"
    }
    
    public var material: FootpathMaterial = .dirt {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty()
            }
        }
    }
    
    var pattern: Int = 0
    
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
        
        material = try container.decode(FootpathMaterial.self, forKey: .material)
        pattern = try container.decode(Int.self, forKey: .pattern)
        
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
        try container.encode(pattern, forKey: .pattern)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let map = map else { return false }
        
        color = material.color.osColor
        
        switch map.footpath.overlay {
        
        case .none:
            
            label.isHidden = true
            
        case .pattern:
            
            label.text = "\(pattern)"
            label.isHidden = false
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        var pattern = GridPattern(value: false)
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            guard let n0 = find(neighbour: c0),
                  let n1 = find(neighbour: c1),
                  let n2 = find(neighbour: ordinal),
                  n0.material.rawValue == material.rawValue,
                  n1.material.rawValue == material.rawValue,
                  n2.material.rawValue == material.rawValue else { continue }
            
            switch ordinal {
            
            case .northWest: pattern.northWest = true
            case .northEast: pattern.northEast = true
            case .southEast: pattern.southEast = true
            default: pattern.southWest = true
            }
        }
        
        for cardinal in Cardinal.allCases {
                    
            guard let neighbour = find(neighbour: cardinal),
                  neighbour.material.rawValue == material.rawValue else { continue }
            
            switch cardinal {
            
            case .north: pattern.north = true
            case .east: pattern.east = true
            case .south: pattern.south = true
            default: pattern.west = true
            }
        }
        
        self.pattern = pattern.id
    }
}

extension FootpathTile2D {
    
    public static func == (lhs: FootpathTile2D, rhs: FootpathTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}

extension FootpathTile2D {
    
    func render(position: Position, corners: [Position]) -> [Euclid.Polygon] {
        
        guard let scene = scene as? Scene2D,
              let tile = scene.map.surface.find(tile: coordinate) else { return [] }
        
        return []
    }
}
