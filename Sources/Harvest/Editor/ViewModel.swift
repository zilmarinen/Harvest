//
//  ViewModel.swift
//  Harvest
//
//  Created by Zack Brown on 10/11/2026.
//

import AppKit
import Deltille
import Euclid

@MainActor
internal class ViewModel {
    
    private(set) var focus: Triangle = .zero
    
    private(set) var hitTest: HitTest = .init(.zero)
    
    internal let lattice: Double = 25.0
}

internal extension ViewModel {
    
    // MARK: Focus
    
    func update(focus value: Triangle) {
        
        focus = value
    }
    
    // MARK: Hit Test
    
    func update(hitTest value: NSPoint) {
        
        let vector = Vector(value.x,
                            0.0,
                            value.y)
        
        hitTest = .init(vector,
                        lattice)
    }
}
