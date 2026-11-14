//
//  Grid.swift
//  Harvest
//
//  Created by Zack Brown on 12/11/2026.
//

import GameplayKit
import SpriteKit

internal class Grid: SKSpriteNode {
    
    private let latticeUniform: SKUniform
    
    internal var lattice: Double {
        
        didSet {
            
            latticeUniform.floatValue = Float(lattice)
        }
    }
    
    internal init(lattice: Double) {
        
        self.lattice = lattice
        
        //TODO: Convert to SKUniform.uniform enum
        self.latticeUniform = .init(.lattice,
                                    value: Float(lattice))
        
        super.init(texture: nil,
                   color: .clear,
                   size: .zero)
        
        shader = .init(.grid,
                       uniforms: [latticeUniform])
        zPosition = -1.0
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
