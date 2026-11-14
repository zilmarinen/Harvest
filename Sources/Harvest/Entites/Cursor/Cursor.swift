//
//  Cursor.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import SpriteKit

internal class Cursor: SKShapeNode {
    
    internal var lattice: Double {
        
        didSet {
            
            update()
        }
    }
    
    internal init(lattice: Double) {
        
        self.lattice = lattice
        
        super.init()
        
        update()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension Cursor {
    
    func update() {
        
        let triangle = Triangle.zero
        
        let vertices = triangle.vertices()
        
        guard let end = vertices.last else { return }
        
        let path = CGMutablePath()
        
        path.move(to: end.vector(lattice))
        
        for vertex in vertices {
            
            path.addLine(to: vertex.vector(lattice))
        }
        
        self.path = path
    }
}
