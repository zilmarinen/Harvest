//
//  Scene2D.swift
//
//  Created by Zack Brown on 26/04/2021.
//

import Euclid
import SpriteKit
import Meadow

public class Scene2D: SKScene, Soilable {
    
    public lazy var cursorObserver: CursorObserver = { CursorObserver(initialState: .idle(position: .zero)) }()
    
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
    
    public let tileset: Tilesets
    
    public let map: Map2D
    
    public required init(size: CGSize, map: Map2D, tileset: Tilesets) {
        
        self.map = map
        self.tileset = tileset
        
        super.init(size: size)
        
        name = "Harvest"
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
        
        addChild(graph)
        addChild(map)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
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
    
    public func convert(pointToWorld point: CGPoint) -> Coordinate {
        
        return Coordinate(x: Int(round(point.x)), y: 0, z: -Int(round(point.y)))
    }
}

extension Scene2D {
    
    func mouseDown(event: NSEvent, eventType: CursorState.EventType) {
        
        switch cursorObserver.state {
            
        case .idle:
            
            let point = convert(pointToWorld: event.location(in: self))
            
            cursorObserver.state = .down(position: .init(start: point, end: point), eventType: eventType)
            
        default: break
        }
    }
    
    func mouseUp(event: NSEvent, eventType: CursorState.EventType) {
     
        switch cursorObserver.state {
            
        case .down(let position, _),
             .tracking(let position, _):
            
            let point = convert(pointToWorld: event.location(in: self))
            
            cursorObserver.state = .up(position: .init(start: position.start, end: point), eventType: eventType)
            
        default: break
        }
    }
    
    func mouseDragged(event: NSEvent, eventType: CursorState.EventType) {
        
        switch cursorObserver.state {
            
        case .down(let position, _),
             .tracking(let position, _):
            
            let point = convert(pointToWorld: event.location(in: self))
            
            cursorObserver.state = .tracking(position: .init(start: position.start, end: point), eventType: eventType)
            
        default: break
        }
    }
}

extension Scene2D {
    
    public override func mouseDown(with event: NSEvent) {
            
        super.mouseDown(with: event)
        
        mouseDown(event: event, eventType: .left)
    }
    
    public override func rightMouseDown(with event: NSEvent) {
        
        super.rightMouseDown(with: event)
        
        mouseDown(event: event, eventType: .right)
    }
    
    public override func mouseUp(with event: NSEvent) {
        
        super.mouseUp(with: event)
        
        mouseUp(event: event, eventType: .left)
    }
    
    public override func rightMouseUp(with event: NSEvent) {
        
        super.rightMouseUp(with: event)
        
        mouseUp(event: event, eventType: .right)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        
        super.mouseDragged(with: event)
        
        mouseDragged(event: event, eventType: .left)
    }
    
    public override func rightMouseDragged(with event: NSEvent) {
        
        super.rightMouseDragged(with: event)
        
        mouseDragged(event: event, eventType: .right)
    }
    
    public override func mouseMoved(with event: NSEvent) {
        
        super.mouseMoved(with: event)
        
        guard cursorObserver.tracksIdleEvents else { return }
        
        switch cursorObserver.state {
            
        case .idle:
            
            let point = convert(pointToWorld: event.location(in: self))
            
            cursorObserver.state = .idle(position: point)
            
        default: break
        }
    }
}
