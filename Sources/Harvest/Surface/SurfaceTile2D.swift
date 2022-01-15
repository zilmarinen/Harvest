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
    
    private var config = SurfaceTileConfig()
    
    private let patternOverlay = OrdinalPatternOverlay()
    private let elevationOverlay = SurfaceElevationOverlay()
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
        
        addChild(patternOverlay)
        addChild(elevationOverlay)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(SurfaceMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
        
        addChild(patternOverlay)
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
        
        patternOverlay.configure(with: config.pattern.ordinals)
        elevationOverlay.configure(with: config.elevation.ordinals)
        
        switch scene.map.surface.overlay {
        
        case .elevation:
            
            label.text = "\(coordinate.y)"
            
        case .none:
            
            label.text = nil
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        config.reset()
        
        for cardinal in Cardinal.allCases {
            
            let n0 = find(neighbour: cardinal)
            
            let m0 = n0?.material ?? .air
            let e0 = n0?.coordinate.y ?? World.Constants.floor
            
            config.pattern.set(value: m0, cardinal: cardinal)
            config.elevation.set(value: e0, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            let n0 = find(neighbour: ordinal)
            
            let m0 = n0?.material ?? .air
            let m1 = config.pattern.value(for: c0)
            let m2 = config.pattern.value(for: c1)
            
            let e0 = n0?.coordinate.y ?? World.Constants.floor
            let e1 = config.elevation.value(for: c0)
            let e2 = config.elevation.value(for: c1)
            
            guard m0 != .air,
                  m1 != .air,
                  m2 != .air else { continue }
            
            config.elevation.set(value: max(e0, e1, e2, coordinate.y), ordinal: ordinal)
                
            config.pattern.set(value: material.max(material: m0.max(material: m1).max(material: m2)), ordinal: ordinal)
            
            config.occupancy.set(value: SurfaceSocket(inner: true, outer: true), ordinal: ordinal)
        }
    }
    
    override var mesh: Mesh {
        
        guard let scene = scene as? Scene2D else { return Mesh.cube() }
        
        let tileset = scene.tileset.surface
        
        var result = Mesh([])
        
        let materials = config.pattern.ordinals.uniqueValues.filter { $0 != .air }
        let chunks = materials.flatMap { config.chunks(for: $0) }.sorted { $0.pattern.area > $1.pattern.area }
        
        var occupancy = config.occupancy
        
        for index in chunks.indices {
            
            let chunk = chunks[index]
            
            let pairs = tileset.tiles(matching: chunk.pattern.bitmask, material: chunk.material, occupancy: occupancy)
            
            guard let tile = index == 0 ? pairs.randomElement(using: &rng) : pairs.first,
                  let crown = tile.crown.mesh,
                  let throne = tile.throne.mesh,
                  let bitmaskIndex = tile.crown.bitmasks.firstIndex(of: chunk.pattern.bitmask) else {
                
                print("Unable to find tiles matching bitmask: \(chunk.pattern.bitmask) for material: \(chunk.material)")
                
                continue
            }
            
            let ordinal = tile.throne.rotations[bitmaskIndex]
            let rotation = Rotation(yaw: Angle(degrees: -90.0 * Double(ordinal.corner)))
            let sockets = tile.throne.sockets.rotated(ordinal: ordinal)
            
            occupancy.subtract(sockets: sockets)
            
            if chunk.elevation > 1 {
                
                for index in 0..<(chunk.elevation - 1) {
                 
                    let offset = Vector(x: 0, y: Double(index) * 0.5, z: 0)
                    let transform = Transform(offset: offset, rotation: rotation)
                                
                    result = result.union(throne.transformed(by: transform))
                }
            }
            
            let offset = Vector(x: 0, y: Double(chunk.elevation - 1) * 0.5, z: 0)
            let transform = Transform(offset: offset, rotation: rotation)
                        
            result = result.union(crown.transformed(by: transform))
        }
        
        return result
    }
}

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}
