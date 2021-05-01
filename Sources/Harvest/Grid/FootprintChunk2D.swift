//
//  FootprintChunk2D.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Meadow
import SpriteKit

public class FootprintChunk2D: SKSpriteNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var footprint: Footprint {
        
        didSet {
            
            if oldValue != footprint {
                
                becomeDirty()
            }
        }
    }
    
    required init(footprint: Footprint) {
        
        self.footprint = footprint
        
        super.init(texture: nil, color: .black, size: .zero)
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        self.footprint = Footprint(coordinate: coordinate, rotation: .north, nodes: [])
        
        super.init(texture: nil, color: .black, size: CGSize(width: 1, height: 1))
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint.coordinate, forKey: .coordinate)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        anchorPoint = .zero
        position = CGPoint(x: CGFloat(footprint.coordinate.x) - 0.5, y: CGFloat(footprint.coordinate.z) - 0.5)
        
        removeAllChildren()
        
        for coordinate in footprint.nodes {

            let node = SKSpriteNode(color: .white, size: CGSize(width: 1.0, height: 1.0))

            node.anchorPoint = .zero
            node.blendMode = .replace
            node.position = CGPoint(x: (footprint.coordinate.x - coordinate.x), y: (footprint.coordinate.z - coordinate.z))

            addChild(node)
        }
        
        isDirty = false
        
        return true
    }
}
