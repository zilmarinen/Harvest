//
//  BridgeChunk2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Foundation
import Meadow
import SpriteKit

public class BridgeChunk2D: FootprintChunk2D<BridgeTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case footprint = "f"
    }
    
    var _footprint: Footprint
    
    public override var footprint: Footprint { _footprint }
    
    required init(coordinate: Coordinate) {
        
        _footprint = Footprint(coordinate: coordinate)
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _footprint = try container.decode(Footprint.self, forKey: .footprint)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(_footprint, forKey: .footprint)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        for tile in tiles {
            
            tile.color = .systemTeal
            
            _ = tile.clean()
        }
        
        return true
    }
}
