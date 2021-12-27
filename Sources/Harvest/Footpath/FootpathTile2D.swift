//
//  FootpathTile2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class FootpathTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public var material: FootpathMaterial = .dirt {
        
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
        
        material = try container.decode(FootpathMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
        
        addChild(label)
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
        
        switch map.footpath.overlay {
        
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

extension FootpathTile2D {
    
    public static func == (lhs: FootpathTile2D, rhs: FootpathTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}
