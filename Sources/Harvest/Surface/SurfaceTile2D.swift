//
//  SurfaceTile2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class SurfaceTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public var material: SurfaceMaterial = .dirt {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    private var pattern = GridPattern<SurfaceMaterial>(value: .air)
    private var volumes: [SurfaceVolume<SurfaceMaterial>] = []
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(SurfaceMaterial.self, forKey: .material)
        
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
              let scene = scene as? Scene2D else { return false }
        
        switch scene.map.surface.overlay {
        
        case .elevation:
            
            label.text = "\(coordinate.y)"
            
        case .none:
            
            label.text = nil
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        for cardinal in Cardinal.allCases {
            
            let m0 = find(neighbour: cardinal)?.material ?? .air
            
            pattern.set(value: material.max(other: m0), cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let m0 = find(neighbour: ordinal)?.material ?? .air
            
            pattern.set(value: material.max(other: m0), ordinal: ordinal)
        }
        
        volumes.removeAll()
        
        //
    }
}

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material && lhs.volumes == rhs.volumes
    }
}
