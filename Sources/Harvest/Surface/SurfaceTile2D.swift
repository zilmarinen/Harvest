//
//  SurfaceTile2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Euclid
import Foundation
import Meadow
import SpriteKit

public class SurfaceTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "tt"
        case material = "m"
        case overlay = "o"
    }
    
    public var tileType: SurfaceTileType = .sloped {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    public var material: SurfaceMaterial = .dirt {
        
        didSet {
            
            if oldValue != material {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    public var overlay: SurfaceOverlay? {
        
        didSet {
            
            if oldValue != overlay {
                
                becomeDirty(recursive: true)
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
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(SurfaceTileType.self, forKey: .tileType)
        material = try container.decode(SurfaceMaterial.self, forKey: .material)
        overlay = try container.decodeIfPresent(SurfaceOverlay.self, forKey: .overlay)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(material, forKey: .material)
        try container.encodeIfPresent(overlay, forKey: .overlay)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let scene = scene as? Scene2D else { return false }
        
        shader = SKShader(shader: .surface)
        shader?.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        
        let attribute = vector_float4(Float(material.color.r),
                                      Float(material.color.g),
                                      Float(material.color.b),
                                      Float(material.color.a))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        switch scene.map.surface.overlay {
        
        case .coordinate:
            
            label.text = "\(coordinate.x),\(coordinate.z)"
            
        case .edge:
            
            label.text = tileType.abbreviation
            
        case .elevation:
            
            label.text = "\(coordinate.y)"
            
        case .material:
            
            label.text = overlay != nil ? "\(pattern)" : material.abbreviation
            
        case .none:
            
            label.text = nil
        }
        
        removeAllChildren()
        
        addChild(label)
        
        let halfSize = CGSize(width: size.width / 2.0, height: size.height / 2.0)
        let stroke: CGFloat = 0.1
        var nodePosition = CGPoint.zero
        var nodeSize = size
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            guard neighbour?.coordinate.y ?? 0 > coordinate.y else { continue }
            
            nodeSize = size
            nodePosition = CGPoint.zero
            
            switch cardinal {
            
            case .north,
                 .south:
                
                nodeSize.height = stroke
                nodePosition.y = (cardinal == .south ? 1 : -1) * (halfSize.height + nodeSize.height / 2.0)
                
            default:
                
                nodeSize.width = stroke
                nodePosition.x = (cardinal == .east ? 1 : -1) * (halfSize.width + nodeSize.width / 2.0)
            }
            
            let node = SKSpriteNode(color: .black, size: nodeSize)
            
            node.position = nodePosition
            node.zPosition = 1
            
            addChild(node)
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        pattern = 0
        
        guard let overlay = overlay else { return }

        let sample = sample()
        
        pattern = sample.overlay.pattern(for: overlay).id
    }
}

extension SurfaceTile2D {
    
    typealias Sample = (elevation: GridPattern<Double>, material: GridPattern<SurfaceMaterial?>, overlay: GridPattern<SurfaceOverlay?>)
    
    func sample() -> Sample {
        
        var elevation = GridPattern<Double>(value: Double(coordinate.y))
        var material = GridPattern<SurfaceMaterial?>(value: self.material)
        var overlay = GridPattern<SurfaceOverlay?>(value: nil)
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            overlay.set(value: neighbour?.coordinate.y == coordinate.y ? neighbour?.overlay : nil, cardinal: cardinal)
            
            if let neighbour = neighbour,
               neighbour.material.rawValue > self.material.rawValue {
                
                material.set(value: neighbour.material, cardinal: cardinal)
            }
            
            guard tileType == .sloped,
                  neighbour?.tileType == .sloped,
                  let n0 = neighbour?.coordinate.y else { continue }
                
            let edge = Double(n0 + coordinate.y) / 2.0
            
            elevation.set(value: edge, cardinal: cardinal)
        }
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            let neighbour = find(neighbour: ordinal)
            let (n0, n1) = (find(neighbour: c0), find(neighbour: c1))
            
            overlay.set(value: neighbour?.coordinate.y == coordinate.y ? neighbour?.overlay : nil, ordinal: ordinal)
            
            let materials = [self.material,
                             neighbour?.material,
                             n0?.material,
                             n1?.material].sorted { $0?.rawValue ?? 0 > $1?.rawValue ?? 0 }
            
            guard let neighbourMaterial = materials.first else { continue }
            
            material.set(value: neighbourMaterial, ordinal: ordinal)
            
            guard tileType == .sloped else { continue }
            
            let tiles = [self, neighbour, n0, n1]
            
            let heights = [coordinate.y,
                           neighbour?.coordinate.y ?? coordinate.y,
                           n0?.coordinate.y ?? coordinate.y,
                           n1?.coordinate.y ?? coordinate.y]
            
            var result = 0.0
            var count = 0
            
            for index in tiles.indices {
                
                let tile = tiles[index]
                
                guard tile?.tileType == .sloped else { continue }
                
                result += Double(heights[index])
                
                count += 1
            }
            
            elevation.set(value: result / Double(count), ordinal: ordinal)
        }
        
        return (elevation, material, overlay)
    }
}

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}

extension SurfaceTile2D {
    
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
        let mc0 = material.color
        
        let apexTile = tileset.tiles(with: pattern).randomElement(using: &rng)
        let apexUVs = apexTile?.uvs ?? UVs(start: .zero, end: .zero)
        let edgeUVs = UVs.corners
        
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
                colors.append(contentsOf: [[mc3, mc2, mc1], [mc2, mc0, mc1]])
                uvs.append(contentsOf: [[auv3, auv2, auv1], [auv2, auv0, auv1]])
                
            case .northEast:
                
                faces.append(contentsOf: [[av1, av3, av2], [av1, av2, v0]])
                colors.append(contentsOf: [[mc1, mc3, mc2], [mc1, mc2, mc0]])
                uvs.append(contentsOf: [[auv1, auv3, auv2], [auv1, auv2, auv0]])
                
            case .southEast:
                
                faces.append(contentsOf: [[v0, av1, av2], [av1, av3, av2]])
                colors.append(contentsOf: [[mc0, mc1, mc2], [mc1, mc3, mc2]])
                uvs.append(contentsOf: [[auv0, auv1, auv2], [auv1, auv3, auv2]])
                
            default:
                
                faces.append(contentsOf: [[av2, v0, av1], [av2, av1, av3]])
                colors.append(contentsOf: [[mc2, mc0, mc1], [mc2, mc1, mc3]])
                uvs.append(contentsOf: [[auv2, auv0, auv1], [auv2, auv1, auv3]])
            }
            
            if n0be3 < ae3 {
                
                let euv0 = edgeUVs.corners[1]
                let euv1 = edgeUVs.edges[0]
                let euv2 = edgeUVs.edges[2]
                let euv3 = edgeUVs.corners[2]
                
                let bv3 = corners[ordinal.corner].lerp(upperCorners[ordinal.corner], World.Constants.yScalar * n0be3)
                
                faces.append(contentsOf: [[av3, av1, bv3]])
                colors.append(contentsOf: [[mc3, mc1, mc3]])
                uvs.append(contentsOf: [[euv0, euv1, euv3]])
                
                if be1 < ae1 {
                    
                    let bv1 = edges[c0.edge].lerp(upperEdges[c0.edge], World.Constants.yScalar * be1)
                    
                    faces.append(contentsOf: [[av1, bv1, bv3]])
                    colors.append(contentsOf: [[mc1, mc1, mc3]])
                    uvs.append(contentsOf: [[euv1, euv2, euv3]])
                }
            }
            
            if n1be3 < ae3 {
                
                let euv0 = edgeUVs.edges[0]
                let euv1 = edgeUVs.corners[0]
                let euv2 = edgeUVs.corners[3]
                let euv3 = edgeUVs.edges[2]
                
                let bv3 = corners[ordinal.corner].lerp(upperCorners[ordinal.corner], World.Constants.yScalar * n1be3)
                
                faces.append(contentsOf: [[av2, av3, bv3]])
                colors.append(contentsOf: [[mc2, mc3, mc3]])
                uvs.append(contentsOf: [[euv0, euv1, euv2]])
                
                if be2 < ae2 {
                    
                    let bv1 = edges[c1.edge].lerp(upperEdges[c1.edge], World.Constants.yScalar * be2)
                    
                    faces.append(contentsOf: [[av2, bv3, bv1]])
                    colors.append(contentsOf: [[mc2, mc3, mc2]])
                    uvs.append(contentsOf: [[euv0, euv2, euv3]])
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
                    
                    vertices.append(Vertex(position, normal, uv, color))
                }
                
                guard let polygon = Polygon(vertices.reversed()) else { continue }
                
                polygons.append(polygon)
            }
        }
        
        return polygons*/
    }
}
