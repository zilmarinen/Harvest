//
//  FootpathTile2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class FootpathTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
        case pattern = "p"
    }
    
    public var material: FootpathMaterial = .dirt {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty()
            }
        }
    }
    
    var pattern: Int = 0
    
    lazy var label: SKLabelNode = {
        
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
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
        
        addChild(label)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(FootpathMaterial.self, forKey: .material)
        pattern = try container.decode(Int.self, forKey: .pattern)
        
        try super.init(from: decoder)
        
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(material, forKey: .material)
        try container.encode(pattern, forKey: .pattern)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let map = map else { return false }
        
        color = material.color.osColor
        
        switch map.footpath.overlay {
        
        case .none:
            
            label.isHidden = true
            
        case .pattern:
            
            label.text = "\(pattern)"
            label.isHidden = false
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        var pattern = GridPattern(value: false)
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            guard let n0 = find(neighbour: c0),
                  let n1 = find(neighbour: c1),
                  let n2 = find(neighbour: ordinal),
                  n0.material.rawValue == material.rawValue,
                  n1.material.rawValue == material.rawValue,
                  n2.material.rawValue == material.rawValue else { continue }
            
            switch ordinal {
            
            case .northWest: pattern.northWest = true
            case .northEast: pattern.northEast = true
            case .southEast: pattern.southEast = true
            default: pattern.southWest = true
            }
        }
        
        for cardinal in Cardinal.allCases {
                    
            guard let neighbour = find(neighbour: cardinal),
                  neighbour.material.rawValue == material.rawValue else { continue }
            
            switch cardinal {
            
            case .north: pattern.north = true
            case .east: pattern.east = true
            case .south: pattern.south = true
            default: pattern.west = true
            }
        }
        
        self.pattern = pattern.id
    }
}

extension FootpathTile2D {
    
    public static func == (lhs: FootpathTile2D, rhs: FootpathTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}

extension FootpathTile2D {
    
    func render(position: Vector, corners: [Vector]) -> [Euclid.Polygon] {
        
        guard let scene = scene as? Scene2D,
              let tile = scene.map.surface.find(tile: coordinate) else { return [] }
        
        collapse()
        
        let tileset = scene.tileset.footpath
        
        let sample = tile.sample()
        let edges = Ordinal.allCases.map { corners[$0.corner].lerp(corners[($0.corner + 1) % 4], 0.5) }
        let upperCorners = corners.map { $0 + Coordinate(x: 0, y: World.Constants.ceiling, z: 0).world }
        let upperEdges = edges.map { $0 + Coordinate(x: 0, y: World.Constants.ceiling, z: 0).world }
        
        let v0 = position + Coordinate(x: 0, y: coordinate.y, z: 0).world
        
        let apexTile = tileset.tiles(with: pattern, material: material).randomElement(using: &rng)
        let apexUVs = apexTile?.uvs ?? UVs.corners
        
        var polygons: [Euclid.Polygon] = []
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            let ae1 = sample.elevation.value(for: c0)
            let ae2 = sample.elevation.value(for: c1)
            let ae3 = sample.elevation.value(for: ordinal)
            
            let av1 = edges[c0.edge].lerp(upperEdges[c0.edge], World.Constants.yScalar * ae1)
            let av2 = edges[c1.edge].lerp(upperEdges[c1.edge], World.Constants.yScalar * ae2)
            let av3 = corners[ordinal.corner].lerp(upperCorners[ordinal.corner], World.Constants.yScalar * ae3)
            
            let auv0 = apexUVs.center
            let auv1 = apexUVs.edges[c0.edge]
            let auv2 = apexUVs.edges[c1.edge]
            let auv3 = apexUVs.corners[ordinal.corner]
            
            var faces: [[Vector]] = []
            let colors: [[Color]] = Array(repeating: Array(repeating: material.color, count: 3), count: 2)
            var uvs: [[Vector]] = []
            
            switch ordinal {
                
            case .northWest:
                
                faces.append(contentsOf: [[av3, av2, av1], [av2, v0, av1]])
                uvs.append(contentsOf: [[auv3, auv2, auv1], [auv2, auv0, auv1]])
                
            case .northEast:
                
                faces.append(contentsOf: [[av1, av3, av2], [av1, av2, v0]])
                uvs.append(contentsOf: [[auv1, auv3, auv2], [auv1, auv2, auv0]])
                
            case .southEast:
                
                faces.append(contentsOf: [[v0, av1, av2], [av1, av3, av2]])
                uvs.append(contentsOf: [[auv0, auv1, auv2], [auv1, auv3, auv2]])
                
            default:
                
                faces.append(contentsOf: [[av2, v0, av1], [av2, av1, av3]])
                uvs.append(contentsOf: [[auv2, auv0, auv1], [auv2, auv1, auv3]])
            }
            
            for faceIndex in faces.indices {
                
                let face = faces[faceIndex]
                let normal = -face.normal()
                let faceColors = colors[faceIndex]
                let faceUVs = uvs[faceIndex]
                
                var vertices: [Vertex] = []
                
                for vertexIndex in face.indices {
                    
                    let position = face[vertexIndex]
                    let color = faceColors[vertexIndex]
                    let uv = faceUVs[vertexIndex]
                    
                    vertices.append(Vertex(position, normal, uv, color))
                }
                
                guard let polygon = Polygon(vertices.reversed()) else { continue }
                
                polygons.append(polygon)
            }
        }
        
        return polygons
    }
}
