//
//  WaterTile2D.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class WaterTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case apexPattern = "ap"
    }
    
    public var tileType: WaterTileType = .water {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    var apexPattern: Int = 0
    
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
        
        tileType = try container.decode(WaterTileType.self, forKey: .tileType)
        apexPattern = try container.decode(Int.self, forKey: .apexPattern)
        
        try super.init(from: decoder)
        
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(apexPattern, forKey: .apexPattern)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard super.clean(),
              let map = map else { return false }
        
        blendMode = .alpha
        color = tileType.color.osColor
        shader = SKShader(shader: .surface)
        shader?.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        
        let attribute = vector_float4(Float(tileType.color.r),
                                      Float(tileType.color.g),
                                      Float(tileType.color.b),
                                      Float(tileType.color.a))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        switch map.water.overlay {
        
        case .none:
            
            label.isHidden = true
            
        case .elevation:
            
            label.text = "\(coordinate.y)"
            label.isHidden = false
        }
        
        return true
    }
    
    override func collapse() {
        
        let sample = sample()
        
        //apexPattern = GridPattern.index(of: sample.tileType.pattern(for: tileType)) + 1
    }
}

extension WaterTile2D {
    
    typealias Sample = (elevation: GridPattern<Double>, tileType: GridPattern<WaterTileType?>)
    
    func sample() -> Sample {
        
        var elevation = GridPattern<Double>(value: Double(coordinate.y))
        var tileType = GridPattern<WaterTileType?>(value: nil)
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            elevation.set(value: Double(neighbour?.coordinate.y ?? coordinate.y) , cardinal: cardinal)
            
            tileType.set(value: neighbour?.tileType, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let neighbour = find(neighbour: ordinal)
            
            elevation.set(value: Double(neighbour?.coordinate.y ?? coordinate.y), ordinal: ordinal)
            
            tileType.set(value: neighbour?.tileType, ordinal: ordinal)
        }
        
        return (elevation, tileType)
    }
}

extension WaterTile2D {
    
    public static func == (lhs: WaterTile2D, rhs: WaterTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}

extension WaterTile2D {
    
    func render(position: Vector, corners: [Vector]) -> [Euclid.Polygon] {
        return []
        /*guard let scene = scene as? Scene2D else { return [] }
        
        collapse()
        
        let tileset = scene.tilesets.surface
        
        let sample = sample()
        let neighbours = Cardinal.allCases.map { find(neighbour: $0)?.sample() ?? sample }
        let edges = Ordinal.allCases.map { corners[$0.corner].lerp(corners[($0.corner + 1) % 4], 0.5) }
        let upperCorners = corners.map { $0 + Coordinate(x: 0, y: World.Constants.ceiling, z: 0).world }
        let upperEdges = edges.map { $0 + Coordinate(x: 0, y: World.Constants.ceiling, z: 0).world }
        
        let v0 = position + Coordinate(x: 0, y: coordinate.y, z: 0).world
        let ttc0 = tileType.color
        
        let apexTile = tileset.tiles(with: apexPattern).randomElement(using: &rng)
        let apexUVs = apexTile?.uvs ?? UVs.corners
        
        var polygons: [Euclid.Polygon] = []
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            let (o0, o1) = ordinal.ordinals
            let (n0, n1) = (neighbours[c0.edge], neighbours[c1.edge])
            
            let ae1 = sample.elevation.value(for: c0)
            let ae2 = sample.elevation.value(for: c1)
            let ae3 = sample.elevation.value(for: ordinal)
            
            let be1 = n0.elevation.value(for: c0.opposite)
            let be2 = n1.elevation.value(for: c1.opposite)
            let n0be3 = n0.elevation.value(for: o1)
            let n1be3 = n1.elevation.value(for: o0)
            
            let av1 = edges[c0.edge].lerp(upperEdges[c0.edge], World.Constants.yScalar * ae1)
            let av2 = edges[c1.edge].lerp(upperEdges[c1.edge], World.Constants.yScalar * ae2)
            let av3 = corners[ordinal.corner].lerp(upperCorners[ordinal.corner], World.Constants.yScalar * ae3)
            
            let ttc1 = sample.tileType.value(for: c0)?.color ?? ttc0
            let ttc2 = sample.tileType.value(for: c1)?.color ?? ttc0
            let ttc3 = sample.tileType.value(for: ordinal)?.color ?? ttc0
            
            let auv0 = apexUVs.center
            let auv1 = apexUVs.edges[c0.edge]
            let auv2 = apexUVs.edges[c1.edge]
            let auv3 = apexUVs.corners[ordinal.corner]
            
            var faces: [[Vector]] = []
            var colors: [[Color]] = []
            var uvs: [[Vector]] = []
            
            switch ordinal {
                
            case .northWest:
                
                faces.append(contentsOf: [[av3, av2, av1], [av2, v0, av1]])
                colors.append(contentsOf: [[ttc3, ttc2, ttc1], [ttc2, ttc0, ttc1]])
                uvs.append(contentsOf: [[auv3, auv2, auv1], [auv2, auv0, auv1]])
                
            case .northEast:
                
                faces.append(contentsOf: [[av1, av3, av2], [av1, av2, v0]])
                colors.append(contentsOf: [[ttc1, ttc3, ttc2], [ttc1, ttc2, ttc0]])
                uvs.append(contentsOf: [[auv1, auv3, auv2], [auv1, auv2, auv0]])
                
            case .southEast:
                
                faces.append(contentsOf: [[v0, av1, av2], [av1, av3, av2]])
                colors.append(contentsOf: [[ttc0, ttc1, ttc2], [ttc1, ttc3, ttc2]])
                uvs.append(contentsOf: [[auv0, auv1, auv2], [auv1, auv3, auv2]])
                
            default:
                
                faces.append(contentsOf: [[av2, v0, av1], [av2, av1, av3]])
                colors.append(contentsOf: [[ttc2, ttc0, ttc1], [ttc2, ttc1, ttc3]])
                uvs.append(contentsOf: [[auv2, auv0, auv1], [auv2, auv1, auv3]])
            }
            
            if n0be3 < ae3 {
                
                let bv3 = corners[ordinal.corner].lerp(upperCorners[ordinal.corner], World.Constants.yScalar * n0be3)
                
                faces.append(contentsOf: [[av3, av1, bv3]])
                colors.append(contentsOf: [[ttc3, ttc1, ttc3]])
                uvs.append(contentsOf: [[.zero, .zero, .zero]])
                
                if be1 < ae1 {
                    
                    let bv1 = edges[c0.edge].lerp(upperEdges[c0.edge], World.Constants.yScalar * be1)
                    
                    faces.append(contentsOf: [[av1, bv1, bv3]])
                    colors.append(contentsOf: [[ttc1, ttc1, ttc3]])
                    uvs.append(contentsOf: [[.zero, .zero, .zero]])
                }
            }
            
            if n1be3 < ae3 {
                
                let bv3 = corners[ordinal.corner].lerp(upperCorners[ordinal.corner], World.Constants.yScalar * n1be3)
                
                faces.append(contentsOf: [[av2, av3, bv3]])
                colors.append(contentsOf: [[ttc2, ttc3, ttc3]])
                uvs.append(contentsOf: [[.zero, .zero, .zero]])
                
                if be2 < ae2 {
                    
                    let bv1 = edges[c1.edge].lerp(upperEdges[c1.edge], World.Constants.yScalar * be2)
                    
                    faces.append(contentsOf: [[av2, bv3, bv1]])
                    colors.append(contentsOf: [[ttc2, ttc3, ttc2]])
                    uvs.append(contentsOf: [[.zero, .zero, .zero]])
                }
            }
            
            for faceIndex in faces.indices {
             
                let face = faces[faceIndex]
                let normal = face.normal()
                let faceColors = colors[faceIndex]
                let faceUVs = uvs[faceIndex]
                
                var vertices: [Vertex] = []
                
                for vertexIndex in face.indices {
                    
                    let position = face[vertexIndex]
                    let color = faceColors[vertexIndex]
                    let uv = faceUVs[vertexIndex]
                    
                    vertices.append(Vertex(position, normal))//, uv, color))
                }
                
                guard let polygon = Polygon(vertices.reversed()) else { continue }
                
                polygons.append(polygon)
            }
        }
        
        return polygons*/
    }
}
