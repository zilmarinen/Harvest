//
//  FootprintChunk2D.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Meadow
import SpriteKit

protocol FootprintChunk2DDataSource {
    
    var footprint: Footprint { get }
}

public class FootprintChunk2D<T: FootprintTile2D>: SKSpriteNode, Codable, FootprintChunk2DDataSource, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var coordinate: Coordinate
    var tiles: [T] = []
    
    public var footprint: Footprint { Footprint(coordinate: coordinate) }
    
    required init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        
        super.init(texture: nil, color: .black, size: .zero)
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        super.init(texture: nil, color: .black, size: CGSize(width: 1, height: 1))
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        anchorPoint = .zero
        position = CGPoint(x: CGFloat(footprint.coordinate.x) - CGFloat(World.Constants.volumeSize), y: CGFloat(footprint.coordinate.z) - CGFloat(World.Constants.volumeSize))
        
        removeAllChildren()
        
        tiles.removeAll()
        
        for coordinate in footprint.nodes {
            
            let tile = T(coordinate: coordinate)

            tile.position = CGPoint(x: (coordinate.x - footprint.coordinate.x), y: (coordinate.z - footprint.coordinate.z))
            
            tiles.append(tile)

            addChild(tile)
        }
        
        isDirty = false
        
        return true
    }
}
