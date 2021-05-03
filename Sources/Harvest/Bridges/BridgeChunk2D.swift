//
//  BridgeChunk2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Foundation
import Meadow
import SpriteKit

public class BridgeChunk2D: FootprintChunk2D<BridgeTile2D> {
    
    private enum CodingKeys: CodingKey {
        
    }
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        //
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        for child in children {
            
            guard let child = child as? SKSpriteNode else { continue }
            
            child.color = .systemTeal
        }
        
        return super.clean()
    }
}

