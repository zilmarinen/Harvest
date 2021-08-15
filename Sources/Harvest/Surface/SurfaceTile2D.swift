//
//  SurfaceTile2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Foundation
import Meadow
import SpriteKit

public class SurfaceTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "tt"
        case edgeType = "et"
        case apexPattern = "ap"
        case edgePatterns = "ep"
        case volumes = "v"
    }
    
    public var tileType: SurfaceTile.TileType = SurfaceTile.TileType() {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    public var edgeType: SurfaceEdgeType = .terraced {
        
        didSet {
            
            if oldValue != edgeType {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    var apexPattern: Int = 0
    var edgePatterns: [Cardinal : Int] = [:]
    var volumes: [Ordinal : TileVolume] = [:]
    
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
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(SurfaceTile.TileType.self, forKey: .tileType)
        edgeType = try container.decode(SurfaceEdgeType.self, forKey: .edgeType)
        apexPattern = try container.decode(Int.self, forKey: .apexPattern)
        edgePatterns = try container.decode([Cardinal : Int].self, forKey: .edgePatterns)
        volumes = try container.decode([Ordinal : TileVolume].self, forKey: .volumes)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(edgeType, forKey: .edgeType)
        try container.encode(apexPattern, forKey: .apexPattern)
        try container.encode(edgePatterns, forKey: .edgePatterns)
        try container.encode(volumes, forKey: .volumes)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let harvest = harvest else { return false }
        
        let tilemap = harvest.surface.tilemap
        
        let spriteColor = Color(red: Double(tileType.primary.rawValue), green: Double(tileType.secondary.rawValue), blue: 0, alpha: 1)
        
        color = spriteColor.color
        texture = tilemap.tileset["\(apexPattern)"]
        shader = tilemap.shader
        
        let attribute = vector_float4(Float(spriteColor.red),
                                      Float(spriteColor.green),
                                      Float(spriteColor.blue),
                                      Float(spriteColor.alpha))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        switch harvest.surface.overlay {
        
        case .coordinate:
            
            label.text = "\(coordinate.x),\(coordinate.z)"
            
        case .edge:
            
            label.text = edgeType.abbreviation
            
        case .elevation,
             .material:
            
            label.text = "\(coordinate.y)"
            
        case .none:
            
            label.text = nil
        }
        
        removeAllChildren()
        
        addChild(label)
        
        let halfSize = CGSize(width: size.width / 2.0, height: size.height / 2.0)
        let stroke: CGFloat = 0.1
        var nodePosition = CGPoint.zero
        var nodeSize = size
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            guard neighbour?.coordinate.y ?? 0 > coordinate.y else { continue }
            
            nodeSize = size
            nodePosition = CGPoint.zero
            
            switch cardinal {
            
            case .north,
                 .south:
                
                nodeSize.height = stroke
                nodePosition.y = (cardinal == .south ? 1 : -1) * (halfSize.height + nodeSize.height / 2.0)
                
            case .east,
                 .west:
                
                nodeSize.width = stroke
                nodePosition.x = (cardinal == .east ? 1 : -1) * (halfSize.width + nodeSize.width / 2.0)
            }
            
            let node = SKSpriteNode(color: .black, size: nodeSize)
            
            node.position = nodePosition
            node.zPosition = 1
            
            addChild(node)
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        super.collapse()
        
        tileType.secondary = tileType.primary
        
        volumes.removeAll()
        
        let sample = sampleNeighbours()
        
        var apices: [TileVolume.Apex] = []
        
        for ordinal in Ordinal.allCases {
            
            //
            /// Generate apex for ordinal volume
            //
            
            apices.append(sample.elevation.apex(for: ordinal, edgeType: edgeType, elevation: coordinate.y))
            
            //
            /// Determine transition between tile types along the ordinal
            //
            
            guard let neighbourTileType = sample.tileType.value(for: ordinal),
                  neighbourTileType > tileType.primary.rawValue,
                  let secondaryTileType = SurfaceTileType(rawValue: neighbourTileType) else { continue }
            
            tileType.secondary = (neighbourTileType > tileType.secondary.rawValue ? secondaryTileType : tileType.secondary)
        }
        
        for ordinal in Ordinal.allCases {
            
            //
            /// Check internal and external edges of each volume to create edges
            //
            
            let (o0, o1) = ordinal.ordinals
            let (c0, c1) = ordinal.cardinals
            let (c2, c3) = ordinal.opposite.cardinals
            
            let apex = apices[ordinal.rawValue]
            let a0 = self.apex(for: o1, cardinal: c0)
            let a1 = self.apex(for: o0, cardinal: c1)
            let a2 = apices[o1.rawValue]
            let a3 = apices[o0.rawValue]
            
            var adjacent: [Cardinal : TileVolume.Apex] = [:]
            
            adjacent[c0] = a0
            adjacent[c1] = a1
            adjacent[c2] = a2
            adjacent[c3] = a3
            
            var edges: [Cardinal : [Ordinal : Double]] = [:]
            
            for cardinal in Cardinal.allCases {
             
                guard let neighbour = adjacent[cardinal] else { continue }
                
                let (o2, o3) = cardinal.ordinals
                let (o4, o5) = cardinal.opposite.ordinals
                
                let h0 = apex.corners[o2.rawValue]
                let h1 = apex.corners[o3.rawValue]
                let h2 = neighbour.corners[o4.rawValue]
                let h3 = neighbour.corners[o5.rawValue]
                
                var corners: [Ordinal : Double] = [:]
                
                if h0 - h3 > Math.epsilon {
                    
                    corners[o2] = h3
                }
                
                if h1 - h2 > Math.epsilon {
                    
                    corners[o3] = h2
                }
                
                if !corners.isEmpty {
                    
                    edges[cardinal] = corners
                }
            }
            
            volumes[ordinal] = TileVolume(apex: apex, edges: edges)
        }
        
        //
        /// Determine transition between tile types along the cardinal
        //
        
        for cardinal in Cardinal.allCases {
            
            edgePatterns[cardinal] = GridPattern.index(of: sample.tileType.edgePattern(for: tileType, cardinal: cardinal)) + 1
            
            guard let neighbourTileType = sample.tileType.value(for: cardinal),
                  neighbourTileType > tileType.primary.rawValue,
                  let secondaryTileType = SurfaceTileType(rawValue: neighbourTileType) else { continue }
            
            tileType.secondary = (neighbourTileType > tileType.secondary.rawValue ? secondaryTileType : tileType.secondary)
        }
        
        apexPattern = GridPattern.index(of: sample.tileType.pattern(for: tileType.primary.rawValue)) + 1
    }
}

extension SurfaceTile2D {
    
    typealias TileNeighbours = (elevation: GridPattern<Int>, tileType: GridPattern<Int?>)
    
    func apex(for ordinal: Ordinal, cardinal: Cardinal) -> TileVolume.Apex {
        
        guard let neighbour = find(neighbour: cardinal) else {
            
            return TileVolume.Apex(corners: Double(coordinate.y) * World.Constants.yScalar)
        }
        
        return neighbour.sampleNeighbours().elevation.apex(for: ordinal, edgeType: neighbour.edgeType, elevation: neighbour.coordinate.y)
    }
    
    func sampleNeighbours() -> TileNeighbours {
        
        var elevation = GridPattern<Int>(value: 0)
        var tileType = GridPattern<Int?>(value: nil)
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            elevation.set(value: neighbour?.coordinate.y ?? coordinate.y , cardinal: cardinal)
            
            tileType.set(value: neighbour?.tileType.primary.rawValue, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let neighbour = find(neighbour: ordinal)
            
            let (c0, c1) = ordinal.cardinals
            
            let n0 = elevation.value(for: c0)
            let n1 = elevation.value(for: c1)
            
            let corner = max(n0, n1, neighbour?.coordinate.y ?? coordinate.y, coordinate.y)
            
            elevation.set(value: corner, ordinal: ordinal)
            
            tileType.set(value: neighbour?.tileType.primary.rawValue, ordinal: ordinal)
        }
        
        return (elevation, tileType)
    }
}

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
