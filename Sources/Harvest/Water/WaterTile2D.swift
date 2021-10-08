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
        
        case material = "m"
    }
    
    public var material: WaterMaterial = .water {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty()
            }
        }
    }
    
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
        
        material = try container.decode(WaterMaterial.self, forKey: .material)
        
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
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard super.clean(),
              let map = map else { return false }
        
        blendMode = .alpha
        color = material.color.osColor
        shader = SKShader(shader: .surface)
        shader?.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        
        let attribute = vector_float4(Float(material.color.r),
                                      Float(material.color.g),
                                      Float(material.color.b),
                                      Float(material.color.a))
        
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
}

extension WaterTile2D {
    
    typealias Sample = (elevation: GridPattern<Double>, material: GridPattern<WaterMaterial?>)
    
    func sample() -> Sample {
        
        var elevation = GridPattern<Double>(value: Double(coordinate.y))
        var material = GridPattern<WaterMaterial?>(value: nil)
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            elevation.set(value: Double(neighbour?.coordinate.y ?? coordinate.y) , cardinal: cardinal)
            
            material.set(value: neighbour?.material, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let neighbour = find(neighbour: ordinal)
            
            elevation.set(value: Double(neighbour?.coordinate.y ?? coordinate.y), ordinal: ordinal)
            
            material.set(value: neighbour?.material, ordinal: ordinal)
        }
        
        return (elevation, material)
    }
}

extension WaterTile2D {
    
    public static func == (lhs: WaterTile2D, rhs: WaterTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}

extension WaterTile2D {
    
    func render(position: Vector, corners: [Vector]) -> [Euclid.Polygon] {
        
        let sample = sample()
        let neighbours = Cardinal.allCases.map { find(neighbour: $0)?.sample() ?? sample }
        let edges = Ordinal.allCases.map { corners[$0.corner].lerp(corners[($0.corner + 1) % 4], 0.5) }
        let upperCorners = corners.map { $0 + Coordinate(x: 0, y: World.Constants.ceiling, z: 0).world }
        let upperEdges = edges.map { $0 + Coordinate(x: 0, y: World.Constants.ceiling, z: 0).world }
        
        let v0 = position + Coordinate(x: 0, y: coordinate.y, z: 0).world
        let mc0 = material.color
        
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
            
            let mc1 = sample.material.value(for: c0)?.color ?? mc0
            let mc2 = sample.material.value(for: c1)?.color ?? mc0
            let mc3 = sample.material.value(for: ordinal)?.color ?? mc0
            
            var faces: [[Vector]] = []
            var colors: [[Color]] = []
            
            switch ordinal {
                
            case .northWest:
                
                faces.append(contentsOf: [[av3, av2, av1], [av2, v0, av1]])
                colors.append(contentsOf: [[mc3, mc2, mc1], [mc2, mc0, mc1]])
                
            case .northEast:
                
                faces.append(contentsOf: [[av1, av3, av2], [av1, av2, v0]])
                colors.append(contentsOf: [[mc1, mc3, mc2], [mc1, mc2, mc0]])
                
            case .southEast:
                
                faces.append(contentsOf: [[v0, av1, av2], [av1, av3, av2]])
                colors.append(contentsOf: [[mc0, mc1, mc2], [mc1, mc3, mc2]])
                
            default:
                
                faces.append(contentsOf: [[av2, v0, av1], [av2, av1, av3]])
                colors.append(contentsOf: [[mc2, mc0, mc1], [mc2, mc1, mc3]])
            }
            
            if n0be3 < ae3 {
                
                let bv3 = corners[ordinal.corner].lerp(upperCorners[ordinal.corner], World.Constants.yScalar * n0be3)
                
                faces.append(contentsOf: [[av3, av1, bv3]])
                colors.append(contentsOf: [[mc3, mc1, mc3]])
                
                if be1 < ae1 {
                    
                    let bv1 = edges[c0.edge].lerp(upperEdges[c0.edge], World.Constants.yScalar * be1)
                    
                    faces.append(contentsOf: [[av1, bv1, bv3]])
                    colors.append(contentsOf: [[mc1, mc1, mc3]])
                }
            }
            
            if n1be3 < ae3 {
                
                let bv3 = corners[ordinal.corner].lerp(upperCorners[ordinal.corner], World.Constants.yScalar * n1be3)
                
                faces.append(contentsOf: [[av2, av3, bv3]])
                colors.append(contentsOf: [[mc2, mc3, mc3]])
                
                if be2 < ae2 {
                    
                    let bv1 = edges[c1.edge].lerp(upperEdges[c1.edge], World.Constants.yScalar * be2)
                    
                    faces.append(contentsOf: [[av2, bv3, bv1]])
                    colors.append(contentsOf: [[mc2, mc3, mc2]])
                }
            }
            
            for faceIndex in faces.indices {
             
                let face = faces[faceIndex]
                let normal = face.normal()
                let faceColors = colors[faceIndex]
                
                var vertices: [Vertex] = []
                
                for vertexIndex in face.indices {
                    
                    let position = face[vertexIndex]
                    let color = faceColors[vertexIndex]
                    let uv = UVs.corners.corners[vertexIndex]
                    
                    vertices.append(Vertex(position, normal, uv, color))
                }
                
                guard let polygon = Polygon(vertices.reversed()) else { continue }
                
                polygons.append(polygon)
            }
        }
        
        return polygons
    }
}
