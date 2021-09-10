//
//  FootpathChunk2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Euclid
import Meadow
import SpriteKit

public class FootpathChunk2D: Chunk2D<FootpathTile2D> {
    
    private enum CodingKeys: String, CodingKey {
        
        case mesh = "m"
    }
    
    required init(coordinate: Coordinate) {
     
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mesh, forKey: .mesh)
    }
}

extension FootpathChunk2D {
    
    var mesh: Mesh {
        
        var polygons: [Euclid.Polygon] = []
        
        let corners = Ordinal.Coordinates.map { $0.world * World.Constants.volumeSize }
        
        for tile in tiles where !tile.isHidden {
            
            let vector = Vector(Double(tile.coordinate.x - bounds.start.x), 0.001, Double(tile.coordinate.z - bounds.start.z))
            
            polygons.append(contentsOf: tile.render(position: vector, corners: corners.map { $0 + vector }))
        }
        
        return Mesh(polygons)
    }
}
