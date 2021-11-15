//
//  SurfaceTile2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class SurfaceTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "tt"
        case material = "m"
        case overlay = "o"
    }
    
    public var tileType: SurfaceTileType = .sloped {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    public var material: SurfaceMaterial = .dirt {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    public var overlay: SurfaceOverlay? {
        
        didSet {
            
            if oldValue != overlay {
                
                becomeDirty(recursive: true)
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
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(SurfaceTileType.self, forKey: .tileType)
        material = try container.decode(SurfaceMaterial.self, forKey: .material)
        overlay = try container.decodeIfPresent(SurfaceOverlay.self, forKey: .overlay)
        
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
        try container.encodeIfPresent(overlay, forKey: .overlay)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let scene = scene as? Scene2D else { return false }
        
        shader = SKShader(shader: .surface)
        shader?.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        
        if let overlay = overlay {
            
            let attribute = vector_float4(Float(overlay.spriteColor.r),
                                          Float(overlay.spriteColor.g),
                                          Float(overlay.spriteColor.b),
                                          Float(overlay.spriteColor.a))
        
            setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        }
        else {
            
            let attribute = vector_float4(Float(material.spriteColor.r),
                                          Float(material.spriteColor.g),
                                          Float(material.spriteColor.b),
                                          Float(material.spriteColor.a))
        
            setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        }
        
        switch scene.map.surface.overlay {
        
        case .coordinate:
            
            label.text = "\(coordinate.x),\(coordinate.z)"
        
        case .elevation:
            
            label.text = "\(coordinate.y)"
            
        case .tileType:
            
            label.text = tileType.abbreviation
            
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
                
            default:
                
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
        
        pattern = 0
        
        guard let overlay = overlay else { return }

        let sample = sample()
        
        pattern = sample.overlay.pattern(for: overlay).id
    }
}

extension SurfaceTile2D {
    
    typealias Sample = (elevation: GridPattern<Double>, material: GridPattern<SurfaceMaterial?>, overlay: GridPattern<SurfaceOverlay?>)
    
    func sample() -> Sample {
        
        var elevation = GridPattern<Double>(value: Double(coordinate.y))
        var material = GridPattern<SurfaceMaterial?>(value: self.material)
        var overlay = GridPattern<SurfaceOverlay?>(value: nil)
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            overlay.set(value: neighbour?.coordinate.y == coordinate.y ? neighbour?.overlay : nil, cardinal: cardinal)
            
            if let neighbour = neighbour,
               neighbour.material.rawValue > self.material.rawValue {
                
                material.set(value: neighbour.material, cardinal: cardinal)
            }
            
            guard tileType == .sloped,
                  neighbour?.tileType == .sloped,
                  let n0 = neighbour?.coordinate.y else { continue }
                
            let edge = Double(n0 + coordinate.y) / 2.0
            
            elevation.set(value: edge, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            let neighbour = find(neighbour: ordinal)
            let (n0, n1) = (find(neighbour: c0), find(neighbour: c1))
            
            overlay.set(value: neighbour?.coordinate.y == coordinate.y ? neighbour?.overlay : nil, ordinal: ordinal)
            
            let materials = [self.material,
                             neighbour?.material,
                             n0?.material,
                             n1?.material].sorted { $0?.rawValue ?? 0 > $1?.rawValue ?? 0 }
            
            guard let neighbourMaterial = materials.first else { continue }
            
            material.set(value: neighbourMaterial, ordinal: ordinal)
            
            guard tileType == .sloped else { continue }
            
            let tiles = [self, neighbour, n0, n1]
            
            let heights = [coordinate.y,
                           neighbour?.coordinate.y ?? coordinate.y,
                           n0?.coordinate.y ?? coordinate.y,
                           n1?.coordinate.y ?? coordinate.y]
            
            var result = 0.0
            var count = 0
            
            for index in tiles.indices {
                
                let tile = tiles[index]
                
                guard tile?.tileType == .sloped else { continue }
                
                result += Double(heights[index])
                
                count += 1
            }
            
            elevation.set(value: result / Double(count), ordinal: ordinal)
        }
        
        return (elevation, material, overlay)
    }
}

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}

extension SurfaceTile2D {
    
    func render(position: Position, corners: [Position]) -> [Euclid.Polygon] {
        
        guard let scene = scene as? Scene2D else { return [] }
        
        return []
    }
}
