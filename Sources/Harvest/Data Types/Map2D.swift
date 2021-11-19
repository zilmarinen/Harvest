//
//  Map2D.swift
//
//  Created by Zack Brown on 26/04/2021.
//

import Foundation
import Meadow
import SpriteKit

public class Map2D: SKNode, Codable, Responder2D, Soilable {
    
    public enum CodingKeys: String, CodingKey {
        
        case actors
        case bridges
        case buildings
        case foliage
        case footpath
        case portals
        case seams
        case stairs
        case surface
        case walls
        case water
        
        case name
        case identifier
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool {
        
        get { !(children as? [Soilable] ?? []).filter { $0.isDirty }.isEmpty }
        set {}
    }
    
    public let actors: Actors2D
    public let bridges: Bridges2D
    public let buildings: Buildings2D
    public let foliage: Foliage2D
    public let footpath: Footpath2D
    public let portals: Portals2D
    public let seams: Seams2D
    public let stairs: Stairs2D
    public let surface: Surface2D
    public let walls: Wall2D
    public let water: Water2D
    
    public var identifier: String
    
    var map: Map2D? { self }
    
    public override init() {
        
        actors = Actors2D()
        bridges = Bridges2D()
        buildings = Buildings2D()
        foliage = Foliage2D()
        footpath = Footpath2D()
        portals = Portals2D()
        seams = Seams2D()
        stairs = Stairs2D()
        surface = Surface2D()
        walls = Wall2D()
        water = Water2D()
        
        identifier = "harvest"
        
        super.init()
        
        name = "Harvest"
        
        addChild(actors)
        addChild(bridges)
        addChild(buildings)
        addChild(foliage)
        addChild(footpath)
        addChild(portals)
        addChild(seams)
        addChild(stairs)
        addChild(surface)
        addChild(walls)
        addChild(water)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        actors = try container.decode(Actors2D.self, forKey: .actors)
        bridges = try container.decode(Bridges2D.self, forKey: .bridges)
        buildings = try container.decode(Buildings2D.self, forKey: .buildings)
        foliage = try container.decode(Foliage2D.self, forKey: .foliage)
        footpath = try container.decode(Footpath2D.self, forKey: .footpath)
        portals = try container.decode(Portals2D.self, forKey: .portals)
        seams = try container.decode(Seams2D.self, forKey: .seams)
        stairs = try container.decode(Stairs2D.self, forKey: .stairs)
        surface = try container.decode(Surface2D.self, forKey: .surface)
        walls = try container.decode(Wall2D.self, forKey: .walls)
        water = try container.decode(Water2D.self, forKey: .water)
        
        identifier  = try container.decode(String.self, forKey: .identifier)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        
        addChild(actors)
        addChild(bridges)
        addChild(buildings)
        addChild(foliage)
        addChild(footpath)
        addChild(portals)
        addChild(seams)
        addChild(stairs)
        addChild(surface)
        addChild(walls)
        addChild(water)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(actors, forKey: .actors)
        try container.encode(bridges, forKey: .bridges)
        try container.encode(buildings, forKey: .buildings)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpath, forKey: .footpath)
        try container.encode(portals, forKey: .portals)
        try container.encode(seams, forKey: .seams)
        try container.encode(stairs, forKey: .stairs)
        try container.encode(surface, forKey: .surface)
        try container.encode(walls, forKey: .walls)
        try container.encode(water, forKey: .water)
        
        try container.encode(name, forKey: .name)
        try container.encode(identifier, forKey: .identifier)
    }
}

extension Map2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        yScale = -1
        
        actors.clean()
        bridges.clean()
        buildings.clean()
        foliage.clean()
        footpath.clean()
        portals.clean()
        seams.clean()
        stairs.clean()
        surface.clean()
        walls.clean()
        water.clean()
        
        surface.zPosition = -1
        
        isDirty = false
        
        return true
    }
}
