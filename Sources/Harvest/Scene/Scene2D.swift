//
//  Scene2D.swift
//
//  Created by Zack Brown on 26/04/2021.
//

import Euclid
import SpriteKit
import Meadow

public class Scene2D: SKScene, Soilable {
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool {
        
        get { map.isDirty }
        set { }
    }
    
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
    
    public required init(size: CGSize, map: Map2D) {
        
        self.map = map
        
        super.init(size: size)
        
        name = "Harvest"
        
        addChild(graph)
        addChild(self.map)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
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
