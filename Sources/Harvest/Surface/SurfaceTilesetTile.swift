//
//  SurfaceTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Euclid
import Foundation
import Meadow

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

public class SurfaceTilesetTile: Codable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case bitmasks = "b"
        case identifier = "id"
        case variation = "va"
        case material = "m"
        case rotations = "r"
        case sockets = "so"
        case volume = "vo"
    }
    
    public let bitmasks: [Int]
    public let identifier: String
    public let variation: Int
    public let material: SurfaceMaterial
    public let rotations: [Ordinal]
    public let sockets: OrdinalPattern<SurfaceSocket>
    public let volume: SurfaceVolume
    
    public init(identifier: String, variation: Int, material: SurfaceMaterial, rotations: [Ordinal], sockets: OrdinalPattern<SurfaceSocket>, volume: SurfaceVolume) {
        
        self.bitmasks = rotations.map { sockets.rotated(ordinal: $0).bitmask }
        self.identifier = identifier
        self.variation = variation
        self.material = material
        self.rotations = rotations
        self.sockets = sockets
        self.volume = volume
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        bitmasks = try container.decode([Int].self, forKey: .bitmasks)
        identifier = try container.decode(String.self, forKey: .identifier)
        variation = try container.decode(Int.self, forKey: .variation)
        material = try container.decode(SurfaceMaterial.self, forKey: .material)
        rotations = try container.decode([Ordinal].self, forKey: .rotations)
        sockets = try container.decode(OrdinalPattern<SurfaceSocket>.self, forKey: .sockets)
        volume = try container.decode(SurfaceVolume.self, forKey: .volume)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bitmasks, forKey: .bitmasks)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(variation, forKey: .variation)
        try container.encode(material, forKey: .material)
        try container.encode(rotations, forKey: .rotations)
        try container.encode(sockets, forKey: .sockets)
        try container.encode(volume, forKey: .volume)
    }
}

extension SurfaceTilesetTile {
    
    public static func == (lhs: SurfaceTilesetTile, rhs: SurfaceTilesetTile) -> Bool {
        
        return lhs.bitmasks == rhs.bitmasks && lhs.identifier == rhs.identifier && lhs.variation == rhs.variation && lhs.material == rhs.material && lhs.rotations == rhs.rotations && lhs.sockets == rhs.sockets && lhs.volume == rhs.volume
    }
}

extension SurfaceTilesetTile {
    
    var mesh: Mesh? {
        
        do {
            
            let asset = try NSDataAsset.asset(named: identifier, in: .module)
            
            return try JSONDecoder().decode(SurfaceTilesetMesh.self, from: asset.data).mesh
        }
        catch {
            
            return nil
        }
    }
}
