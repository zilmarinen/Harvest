//
//  EditorScene.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import SpriteKit

internal class EditorScene: SKScene {
    
    private let surface = Surface()
    private let water = Water()
    
    internal let lattice: Double
    
    internal init(_ lattice: Double) {
        
        self.lattice = lattice
    
        super.init(size: .zero)
        
        addChild(surface)
        addChild(water)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

internal extension EditorScene {
    
    func clean() {
        
        surface.clean()
        water.clean()
    }
}
