//
//  PortalChunk2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow
import SpriteKit

public class PortalChunk2D: FootprintChunk2D<PortalTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case segue = "s"
        case identifier = "i"
        case portalType = "t"
    }
    
    public var identifier: String = ""
    public var segue = PortalSegue(direction: .north, scene: "", identifier: "")
    public var portalType: PortalType = .seam
    
    public override var footprint: Footprint? {
        
        get { Footprint(coordinate: coordinate) }
        set {}
    }
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        segue = try container.decode(PortalSegue.self, forKey: .segue)
        identifier = try container.decode(String.self, forKey: .identifier)
        portalType = try container.decode(PortalType.self, forKey: .portalType)
        
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
        try container.encode(portalType, forKey: .portalType)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        for child in tiles {
            
            child.color = .systemYellow
        }
        
        return super.clean()
    }
}
