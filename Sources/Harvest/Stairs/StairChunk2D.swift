//
//  StairChunk2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class StairChunk2D: FootprintChunk2D<StairTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case footprint = "f"
        case stairType = "t"
        case direction = "d"
        case elevation = "e"
    }
    
    var _footprint: Footprint
    public var stairType: StairType = .stone
    public var direction: Cardinal = .north
    public var elevation = 1
    
    public override var footprint: Footprint { _footprint }
    
    required init(coordinate: Coordinate) {
        
        _footprint = Footprint(coordinate: coordinate)
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _footprint = try container.decode(Footprint.self, forKey: .footprint)
        stairType = try container.decode(StairType.self, forKey: .stairType)
        direction = try container.decode(Cardinal.self, forKey: .direction)
        elevation = try container.decode(Int.self, forKey: .elevation)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(_footprint, forKey: .footprint)
        try container.encode(stairType, forKey: .stairType)
        try container.encode(direction, forKey: .direction)
        try container.encode(elevation, forKey: .elevation)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        for tile in tiles {
            
            tile.color = .systemOrange
            
            _ = tile.clean()
        }
        
        return true
    }
}
