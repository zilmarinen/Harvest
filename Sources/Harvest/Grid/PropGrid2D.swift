//
//  PropGrid2D.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Meadow
import SpriteKit

public class PropGrid2D<C: PropChunk2D<T>, T: PropTile2D>: SKNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case chunks = "c"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var chunks: [C] = []
    
    override init() {
        
        super.init()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([C].self, forKey: .chunks)
        
        super.init()
        
        for chunk in chunks {
            
            addChild(chunk)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(chunks, forKey: .chunks)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
    
    public typealias ChunkConfiguration = ((C) -> Void)
    
    public func add(prop: Prop, coordinate: Coordinate, rotation: Cardinal, configure: ChunkConfiguration? = nil) -> C? {
        
        let footprint = Footprint(coordinate: coordinate, rotation: rotation, nodes: prop.footprint.nodes)
        
        guard validate(footprint: footprint) else { return nil }
        
        let chunk = C(coordinate: coordinate, direction: rotation)
        
        configure?(chunk)
        
        chunks.append(chunk)
        
        addChild(chunk)
        
        becomeDirty()
        
        return chunk
    }
    
    func validate(footprint: Footprint) -> Bool {
        
        for coordinate in footprint.nodes {
            //TODO: check prop does not intersect with walls and other non-prop types
            guard let map = map,
                  map.buildings.find(chunk: coordinate) == nil,
                  map.foliage.find(chunk: coordinate) == nil,
                  map.footpath.find(tile: coordinate) == nil,
                  map.portals.find(chunk: coordinate) == nil,
                  map.stairs.find(chunk: coordinate) == nil,
                  map.surface.find(tile: coordinate) != nil,
                  map.water.find(tile: coordinate) == nil else { return false }
        }
        
        return true
    }
}

extension PropGrid2D {
    
    public func find(chunk coordinate: Coordinate) -> C? {
        
        return chunks.first { $0.footprint.intersects(coordinate: coordinate) }
    }
    
    func find(chunk footprint: Footprint) -> C? {
        
        return chunks.first { $0.footprint.intersects(footprint: footprint) }
    }
    
    public func remove(chunk coordinate: Coordinate) {
        
        guard let chunk = find(chunk: coordinate),
              let index = chunks.firstIndex(of: chunk) else { return }
        
        chunks.remove(at: index)
        
        chunk.removeFromParent()
        
        becomeDirty()
    }
}
