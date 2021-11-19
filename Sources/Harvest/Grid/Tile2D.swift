//
//  Tile2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class Tile2D: SKNode, Codable, Collapsible, Renderable, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    public var neighbours = GridPattern<Tile2D?>(value: nil) {
    
        didSet {
            
            becomeDirty(recursive: true)
        }
    }
    
    internal lazy var label: SKLabelNode = {
        
        let node = SKLabelNode()
        
        node.fontSize = 7
        node.fontColor = .black
        node.blendMode = .replace
        node.verticalAlignmentMode = .center
        node.xScale = 0.1
        node.yScale = -0.1
        node.zPosition = 1
        
        return node
    }()
    
    var mesh: Mesh { fatalError("mesh has not been implemented") }
    
    required init(coordinate: Coordinate) {
            
        self.coordinate = coordinate
        
        super.init()
        
        addChild(label)
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        super.init()
        
        addChild(label)
        
        becomeDirty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    @discardableResult func becomeDirty(recursive: Bool) -> Bool {
        
        if recursive {
            
            for cardinal in Cardinal.allCases {
                
                guard let neighbour = find(neighbour: cardinal) else { continue }
                
                neighbour.becomeDirty()
            }
            
            for ordinal in Ordinal.allCases {
                
                guard let neighbour = find(neighbour: ordinal) else { continue }
                
                neighbour.becomeDirty()
            }
        }
        
        guard !isDirty else { return false }
        
        isDirty = true
        
        ancestor?.child(didBecomeDirty: self)
        
        return true
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty,
              let parent = parent as? Chunk2D<Self> else { return false }
        
        position = CGPoint(x: coordinate.x - parent.bounds.start.x, y: coordinate.z - parent.bounds.start.z)
        
        isDirty = false
        
        return true
    }
    
    func collapse() {}
}

extension Tile2D {
    
    public static func == (lhs: Tile2D, rhs: Tile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
}

extension Tile2D {
    
    func add(neighbour: Tile2D, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.set(value: neighbour, cardinal: cardinal)
        
        if neighbour.neighbours.value(for: cardinal.opposite) != self {
            
            neighbour.add(neighbour: self, cardinal: cardinal.opposite)
        }
        
        becomeDirty(recursive: true)
    }
    
    func add(neighbour: Tile2D, ordinal: Ordinal) {
        
        remove(neighbour: ordinal)
        
        neighbours.set(value: neighbour, ordinal: ordinal)
        
        if neighbour.neighbours.value(for: ordinal.opposite) != self {
            
            neighbour.add(neighbour: self, ordinal: ordinal.opposite)
        }
        
        becomeDirty(recursive: true)
    }
    
    func find(neighbour cardinal: Cardinal) -> Self? {
        
        return neighbours.value(for: cardinal) as? Self
    }
    
    func find(neighbour ordinal: Ordinal) -> Self? {
        
        return neighbours.value(for: ordinal) as? Self
    }
    
    func remove(neighbour cardinal: Cardinal) {
        
        guard let neighbour = neighbours.value(for: cardinal) else { return }
        
        neighbours.set(value: nil, cardinal: cardinal)
        
        if neighbour.neighbours.value(for: cardinal.opposite) == self {
            
            neighbour.remove(neighbour: cardinal.opposite)
        }
        
        becomeDirty(recursive: true)
    }
    
    func remove(neighbour ordinal: Ordinal) {
        
        guard let neighbour = neighbours.value(for: ordinal) else { return }
        
        neighbours.set(value: nil, ordinal: ordinal)
        
        if neighbour.neighbours.value(for: ordinal.opposite) == self {
            
            neighbour.remove(neighbour: ordinal.opposite)
        }
        
        becomeDirty(recursive: true)
    }
}
