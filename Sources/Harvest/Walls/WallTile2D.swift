//
//  WallTile2D.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class WallTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public var material: WallMaterial = .concrete {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty()
            }
        }
    }
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(WallMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(material, forKey: .material)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let map = map else { return false }
        
        switch map.walls.overlay {
        
        case .none:
            
            label.isHidden = true
            
        case .material:
            
            label.text = "\(material.rawValue)"
            label.isHidden = false
        }
        
        return super.clean()
    }
    
    override var mesh: Mesh {
        
        //TODO: implement mesh generation
        return Mesh.cube()
    }
}

extension WallTile2D {
    
    public static func == (lhs: WallTile2D, rhs: WallTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}
