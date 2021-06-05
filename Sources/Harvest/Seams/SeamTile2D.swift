//
//  SeamTile2D.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import Foundation
import Meadow
import SpriteKit

public class SeamTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case segue = "s"
        case identifier = "i"
    }
    
    public var identifier: String = ""
    public var segue = PortalSegue(direction: .north, scene: "", identifier: "")
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        segue = try container.decode(PortalSegue.self, forKey: .segue)
        identifier = try container.decode(String.self, forKey: .identifier)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(segue, forKey: .segue)
        try container.encode(identifier, forKey: .identifier)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        color = .systemIndigo
        
        return super.clean()
    }
}
