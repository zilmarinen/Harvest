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
    private var elevation = GridPattern<Int>(value: 0)
    
    private let overlay = OrdinalPatternOverlay()
    private let elevationOverlay = SurfaceElevationOverlay()
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
        
        addChild(overlay)
        addChild(elevationOverlay)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(SurfaceMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
        
        addChild(overlay)
        addChild(elevationOverlay)
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
        
        overlay.configure(with: pattern.ordinals)
        elevationOverlay.configure(with: elevation.ordinals)
        
        switch scene.map.surface.overlay {
        
        case .elevation:
            
            label.text = "\(coordinate.y)"
            
        case .none:
            
            label.text = nil
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        pattern.set(value: .air)
        elevation.set(value: World.Constants.floor)
        
        for cardinal in Cardinal.allCases {
            
            let n0 = find(neighbour: cardinal)
            
            let m0 = n0?.material ?? .air
            let e0 = n0?.coordinate.y ?? World.Constants.floor
            
            pattern.set(value: material.max(other: m0), cardinal: cardinal)
            elevation.set(value: e0, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            let n0 = find(neighbour: ordinal)
            
            let m0 = n0?.material ?? .air
            let m1 = pattern.value(for: c0)
            let m2 = pattern.value(for: c1)
            
            let e0 = n0?.coordinate.y ?? World.Constants.floor
            let e1 = elevation.value(for: c0)
            let e2 = elevation.value(for: c1)
            
            pattern.set(value: material.max(other: m0.max(other: m1).max(other: m2)), ordinal: ordinal)
            
            guard find(neighbour: c0) != nil,
                  find(neighbour: c1) != nil else { continue }
            
            elevation.set(value: max(e0, e1, e2, coordinate.y), ordinal: ordinal)
        }
    }
    
    override var mesh: Mesh {
        
        guard let scene = scene as? Scene2D else { return Mesh.cube() }
        
        let tileset = scene.tileset.surface
        let maximumElevation = elevation.ordinals.max
        
        var style: SurfaceStyle? = nil
        
        var result = Mesh([])
        
        for index in 1...maximumElevation {
            
            var layerPattern = SurfaceSockets(value: .air)
            
            for ordinal in Ordinal.allCases {
                
                let e0 = elevation.value(for: ordinal)
                let m0 = pattern.value(for: ordinal)
                
                guard m0 != .air else { continue }
                
                if e0 >= index {
                    
                    layerPattern.lower.set(value: m0, ordinal: ordinal)
                }
                
                if e0 >= (index + 1) {
                    
                    layerPattern.upper.set(value: m0, ordinal: ordinal)
                }
            }
            
            guard layerPattern.upper.contains(value: .air) else { continue }
            
            let matchingBitmask = tileset.tiles(matching: layerPattern.bitmask, style: style)
            
            let matchingRotation = matchingBitmask.compactMap { $0.sockets.rotation(matching: layerPattern) != nil ? $0 : nil }
            
            guard let tile = matchingRotation.randomElement(using: &rng),
                  let direction = tile.sockets.rotation(matching: layerPattern),
                  let mesh = tile.mesh else {
                
                      print("Unable to find tile [\(layerPattern.bitmask)]\nMatching bitmask: [\(matchingBitmask.count)]\nMatching rotation: [\(matchingRotation.count)]\npattern:\n \(layerPattern)")
                
                continue
            }
            
            let offset = Distance(x: 0, y: Double(index - 1), z: 0)
            let rotation = Rotation(yaw: Angle(degrees: 90.0 * Double(direction.edge)))
            let transform = Transform(offset: offset, rotation: rotation)
                        
            result = result.union(mesh.transformed(by: transform))
            
            style = tile.style
        }
        
        return result
    }
}

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}
