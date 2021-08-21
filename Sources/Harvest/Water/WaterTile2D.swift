//
//  WaterTile2D.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Foundation
import Meadow
import SpriteKit

public class WaterTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case apexPattern = "ap"
        case volume = "v"
    }
    
    public var tileType: WaterTileType = .water {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    var apexPattern: Int = 0
    var volume: TileVolume = TileVolume(apex: TileVolume.Apex(corners: 0), edges: [:])
    
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
        
        tileType = try container.decode(WaterTileType.self, forKey: .tileType)
        apexPattern = try container.decode(Int.self, forKey: .apexPattern)
        volume = try container.decode(TileVolume.self, forKey: .volume)
        
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
        try container.encode(apexPattern, forKey: .apexPattern)
        try container.encode(volume, forKey: .volume)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard super.clean(),
              let map = map else { return false }
        
        let tilemap = map.water.tilemap
        
        blendMode = .alpha
        color = tileType.color.color
        shader = tilemap.shader
        
        let attribute = vector_float4(Float(tileType.color.red),
                                      Float(tileType.color.green),
                                      Float(tileType.color.blue),
                                      Float(tileType.color.alpha))
        
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
    
    override func collapse() {
        
        super.collapse()
        
        let sample = sampleNeighbours()
        
        var edges: [Cardinal : [Ordinal : Double]] = [:]
        
        for cardinal in Cardinal.allCases {
            
            let height = sample.elevation.value(for: cardinal)
            
            guard height < coordinate.y else { continue }
            
            let corner = Double(height) * World.Constants.yScalar
            
            let (o0, o1) = cardinal.ordinals
            
            edges[cardinal] = [o0 : corner,
                               o1 : corner]
        }
        
        volume = TileVolume(apex: TileVolume.Apex(corners: Double(coordinate.y) * World.Constants.yScalar), edges: edges)
        apexPattern = GridPattern.index(of: sample.tileType.pattern(for: tileType.rawValue)) + 1
    }
}

extension WaterTile2D {
    
    typealias TileNeighbours = (elevation: GridPattern<Int>, tileType: GridPattern<Int?>)
    
    func sampleNeighbours() -> TileNeighbours {
        
        var elevation = GridPattern<Int>(value: 0)
        var tileType = GridPattern<Int?>(value: nil)
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            elevation.set(value: neighbour?.coordinate.y ?? coordinate.y , cardinal: cardinal)
            
            tileType.set(value: neighbour?.tileType.rawValue, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let neighbour = find(neighbour: ordinal)
            
            elevation.set(value: neighbour?.coordinate.y ?? coordinate.y, ordinal: ordinal)
            
            tileType.set(value: neighbour?.tileType.rawValue, ordinal: ordinal)
        }
        
        return (elevation, tileType)
    }
}

extension WaterTile2D {
    
    public static func == (lhs: WaterTile2D, rhs: WaterTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
