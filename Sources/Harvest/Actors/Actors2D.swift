//
//  Actors2D.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Meadow
import SpriteKit

public class Actors2D: SKNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case npcs = "n"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var npcs: [Actor2D] = []
    
    override init() {
        
        super.init()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        npcs = try container.decode([Actor2D].self, forKey: .npcs)
        
        super.init()
        
        for actor in npcs {
            
            addChild(actor)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(npcs, forKey: .npcs)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for actor in npcs {
            
            actor.clean()
        }
        
        isDirty = false
        
        return true
    }
    
    public typealias ActorConfiguration = ((Actor2D) -> Void)
        
    public func add(actor coordinate: Coordinate, configure: ActorConfiguration? = nil) -> Actor2D? {
        
        guard validate(coordinate: coordinate) else { return nil }
        
        let actor = Actor2D(coordinate: coordinate)
        
        npcs.append(actor)
        
        addChild(actor)
        
        configure?(actor)
        
        becomeDirty()
        
        return actor
    }
    
    func validate(coordinate: Coordinate) -> Bool {
        
        guard let map = map,
              map.buildings.find(chunk: coordinate) == nil,
              map.foliage.find(chunk: coordinate) == nil,
              map.portals.find(chunk: coordinate) == nil,
              map.stairs.find(chunk: coordinate) == nil,
              map.surface.find(tile: coordinate) != nil,
              map.water.find(tile: coordinate) == nil else { return false }
        
        return true
    }
}

extension Actors2D {
    
    public func find(actor coordinate: Coordinate) -> Actor2D? {
        
        return npcs.first { $0.coordinate.xz == coordinate.xz }
    }
    
    public func remove(actor coordinate: Coordinate) {
        
        guard let actor = find(actor: coordinate),
              let index = npcs.firstIndex(of: actor) else { return }
        
        npcs.remove(at: index)
        
        actor.removeFromParent()
        
        becomeDirty()
    }
}
