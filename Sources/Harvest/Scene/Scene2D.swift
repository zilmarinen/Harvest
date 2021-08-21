//
//  Scene2D.swift
//
//  Created by Zack Brown on 26/04/2021.
//

import SpriteKit
import Meadow

public class Scene2D: SKScene, Codable, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case name = "n"
        case backgroundColor = "c"
        case map = "m"
        case size = "s"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public lazy var graph: SKSpriteNode = {
        
        let node = SKSpriteNode(color: .white, size: size)
        
        let shader = SKShader(shader: .graph)
        
        let value = vector_float2(Float(size.width),
                                  Float(size.height))
        
        shader.uniforms = [ SKUniform(name: SKUniform.Uniform.size.rawValue, vectorFloat2: value) ]
        
        node.blendMode = .replace
        node.shader = shader
        node.zPosition = -2
        
        return node
    }()
    
    public let map: Map2D
    
    public init(size: CGSize, map: Map2D? = nil) {
        
        self.map = map ?? Map2D()
        
        super.init(size: size)
        
        name = "Harvest"
        
        addChild(graph)
        addChild(self.map)
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        map = try container.decode(Map2D.self, forKey: .map)
        let size = try container.decode(CGSize.self, forKey: .size)
        
        super.init(size: size)
        
        let color = try container.decode(Color.self, forKey: .backgroundColor)
        
        backgroundColor = color.color
        name = try container.decode(String.self, forKey: .name)
        
        addChild(graph)
        addChild(map)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(size, forKey: .size)
        try container.encode(map, forKey: .map)
        
        let color = Color(red: Double(backgroundColor.redComponent), green: Double(backgroundColor.greenComponent), blue: Double(backgroundColor.blueComponent), alpha: Double(backgroundColor.alphaComponent))
        
        try container.encode(color, forKey: .backgroundColor)
    }
    
    public override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
    }
    
    public override func update(_ currentTime: TimeInterval) {
        
        clean()
    }
}

extension Scene2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        graph.size = size
        
        map.clean()
        
        isDirty = false
        
        return true
    }
}

extension Scene2D {
    
    public func hitTest(point: CGPoint) -> Coordinate {
        
        let point = convertPoint(fromView: point)
        
        return Coordinate(x: Int(round(point.x)), y: 0, z: -Int(round(point.y)))
    }
}
