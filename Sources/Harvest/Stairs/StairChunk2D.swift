//
//  StairChunk2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

public class StairChunk2D: FootprintChunk2D<StairTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case stairType = "t"
        case width = "w"
        case height = "h"
        case elevation = "e"
    }
    
    public override var footprint: Footprint {
        
        let bounds = GridBounds(start: coordinate, end: coordinate + Coordinate(x: width - 1, y: 0, z: height - 1))
        
        return Footprint(bounds: bounds)
    }
    
    public var stairType: StairType = .stone
    public var width: Int = 0
    public var height: Int = 0
    public var elevation = 1
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        stairType = try container.decode(StairType.self, forKey: .stairType)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        elevation = try container.decode(Int.self, forKey: .elevation)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(stairType, forKey: .stairType)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
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
