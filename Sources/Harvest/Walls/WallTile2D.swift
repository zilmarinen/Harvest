//
//  WallTile2D.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Foundation
import Meadow
import SpriteKit

public class WallTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case pattern = "p"
        case material = "m"
        case external = "e"
    }
    
    public var tileType: WallTileType = .wall {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    public var material: WallTileMaterial = .concrete {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty()
            }
        }
    }
    
    var pattern: WallPattern = .north
    var external: Bool = false
    
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
        
        tileType = try container.decode(WallTileType.self, forKey: .tileType)
        pattern = try container.decode(WallPattern.self, forKey: .pattern)
        material = try container.decode(WallTileMaterial.self, forKey: .material)
        external = try container.decode(Bool.self, forKey: .external)
        
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
        try container.encode(external, forKey: .external)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let harvest = harvest else { return false }
        
        let tilemap = harvest.footpath.tilemap
        
        blendMode = .replace
        color = tileType.color.color
        //texture = tilemap.tileset["\(pattern)_\(tileType.rawValue)"]
        //shader = tilemap.shader
        
        switch harvest.walls.overlay {
        
        case .none:
            
            label.isHidden = true
            
        case .type:
            
            label.text = "\(pattern.rawValue)"
            label.isHidden = false
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        super.collapse()
        
        var surface = GridPattern(value: false)
        
        for cardinal in Cardinal.allCases {
            
            guard let neighbour = harvest?.surface.find(tile: coordinate + cardinal.coordinate) else { continue }
            
            surface.set(value: neighbour.coordinate.y == coordinate.y, cardinal: cardinal)
        }
        
        let edge = neighbours.value(for: .north) == nil ? Cardinal.north : .east
        
        self.external = !surface.value(for: edge) || !surface.value(for: edge.opposite)
        
        guard !neighbours.isParallel else {
            
            var pattern = WallPattern(cardinal: edge)
            
            if external {
                
                for cardinal in Cardinal.allCases {
                    
                    if !surface.value(for: cardinal) {
                        
                        pattern = WallPattern(cardinal: cardinal)
                        
                        break
                    }
                }
            }
            
            self.pattern = pattern
            
            switch tileType {
            
            case .wall,
                 .edge:
                
                var edges: [Cardinal] = []
                
                for cardinal in Cardinal.allCases {
                    
                    guard let neighbour = find(neighbour: cardinal) else { continue }
                 
                    if !neighbour.neighbours.isParallel {
                        
                        edges.append(cardinal)
                    }
                }
                
                guard edges.count == 1,
                        let cardinal = edges.first else {
                    
                    tileType = .wall
                          
                    break
                }
                
                self.pattern = WallPattern(cardinal: cardinal)
                
                let (c0, _) = cardinal.cardinals
                
                tileType = .edge(left: surface.value(for: c0))
                
            default: break
            }
            
            return
        }
        
        tileType = (tileType != .door && tileType != .window) ? .corner : tileType
        
        var pattern: WallPattern? = nil
        
        for cardinal in Cardinal.allCases {
            
            guard neighbours.value(for: cardinal) != nil else { continue }
            
            let edge = WallPattern(cardinal: cardinal)
            
            pattern = pattern == nil ? edge : pattern!.union(edge)
        }
        
        self.pattern = pattern ?? .north
    }
}

extension WallTile2D {
    
    public static func == (lhs: WallTile2D, rhs: WallTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
