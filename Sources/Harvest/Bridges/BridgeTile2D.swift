//
//  BridgeTile2D.swift
//
//  Created by Zack Brown on 03/05/2021.
//

import Foundation
import Meadow
import SpriteKit

public class BridgeTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case pattern = "p"
        case material = "m"
    }
    
    public var tileType: BridgeTileType = .path {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    public var material: BridgeMaterial = .stone {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty()
            }
        }
    }
    
    var pattern: WallPattern = .north
    
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
        
        tileType = try container.decode(BridgeTileType.self, forKey: .tileType)
        pattern = try container.decode(WallPattern.self, forKey: .pattern)
        material = try container.decode(BridgeMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
        
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(pattern, forKey: .pattern)
        try container.encode(material, forKey: .material)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let harvest = harvest else { return false }
        
        blendMode = .replace
        color = material.color.color
        
        switch harvest.bridges.overlay {
        
        case .none:
            
            label.isHidden = true
            
        case .tileType:
            
            label.text = tileType.abbreviation.capitalized
            label.isHidden = false
            
        case .pattern:
            
            label.text = "\(pattern.rawValue)"
            label.isHidden = false
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        super.collapse()
        
        switch neighbours.cardinalCount {
            
        case 2:
            
            pattern = []
            var lhs = false
            
            for cardinal in Cardinal.allCases {
                
                guard neighbours.value(for: cardinal) != nil else { continue }
                
                let surface = harvest?.surface.find(tile: coordinate + cardinal.coordinate)?.coordinate.y ?? World.Constants.floor
                
                if surface != coordinate.y {
                    
                    let (c0, _) = cardinal.cardinals
                 
                    pattern.insert(WallPattern(cardinal: cardinal))
                    lhs = neighbours.value(for: c0) == nil
                }
            }
            
            tileType = .corner(lhs)
            
            return
            
        case 4:
            
            tileType = .path
            pattern = [.north, .east, .south, .west]
            
            return
            
        default:
            
            tileType = .path
            pattern = [.north, .east, .south, .west]
            
            for cardinal in Cardinal.allCases {
                
                let neighbour = neighbours.value(for: cardinal)
                
                if neighbour == nil {
                
                    let surface = harvest?.surface.find(tile: coordinate + cardinal.coordinate)?.coordinate.y ?? World.Constants.floor
                    
                    if surface != coordinate.y {
                        
                        tileType = .wall
                        pattern = WallPattern(cardinal: cardinal)
                        
                        let (c0, _) = cardinal.cardinals
                        
                        for edge in Cardinal.allCases {
                            
                            if neighbours.value(for: edge)?.neighbours.cardinalCount == 2 {
                            
                                tileType = .edge(edge == c0)
                                
                                break
                            }
                        }
                        
                        break
                    }
                    
                    return
                }
            }
        }
    }
}
