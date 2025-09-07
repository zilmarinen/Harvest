//
//  TerrainChunk.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import Deltille
import RealityKit

internal class TerrainChunk: Entity,
                             @preconcurrency Soilable {
    
    internal var isDirty: Bool = false
    
    internal let triangle: Triangle
    
    init(triangle: Triangle) {
        
        self.triangle = triangle
        
        super.init()
        print("Creating new terrain chunk: \(triangle.id)")
        position = .init(triangle.position(.chunk))
    }
    
    @available(*, unavailable)
    @MainActor @preconcurrency required init() { fatalError("init() has not been implemented") }
}
