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
    
    internal var lattice: Double {
        
        didSet {
            
            surface.lattice = lattice
            water.lattice = lattice
        }
    }
    
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

// MARK: Surface

internal extension EditorScene {
    
    func set(surface biome: Biome? = nil,
             _ elevation: Int? = nil,
             for vertex: Triangle.Vertex,
             with footprint: Set<Triangle.Vertex>) {
        
        let elevation = elevation ?? surface.value(for: vertex)?.elevation ?? 0
        
        if elevation > 0 {
            
            let biome = biome ?? surface.value(for: vertex)?.biome ?? .boreal
            
            surface.set(.init(vertex: vertex,
                              footprint: footprint,
                              biome: biome,
                              elevation: elevation))
        }
        else {
            
            surface.remove([vertex])
        }
        
        water.propagate(Set(vertex.tiles))
    }
}

// MARK: Water

internal extension EditorScene {
    
    func set(water fluid: Fluid? = nil,
             _ elevation: Int? = nil,
             for triangle: Triangle,
             with footprint: Set<Triangle>) {
        
        let elevation = elevation ?? water.value(for: triangle)?.elevation ?? 0
        
        guard elevation > 0 else {
            
            return water.remove([triangle])
        }
            
        let fluid = fluid ?? water.value(for: triangle)?.fluid ?? .ocean
            
        water.set(.init(vertex: triangle,
                        footprint: footprint,
                        fluid: fluid,
                        elevation: elevation))
    }
}
