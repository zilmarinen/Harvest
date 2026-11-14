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
    
    private static let latticeMaximum = 100.0
    private static let latticeMinimum = 10.0
    
    private(set) var focus: Triangle = .zero
    
    private(set) var hitTest: HitTest = .init(.zero)
    
    private(set) lazy var lattice: Double = (Self.latticeMaximum - Self.latticeMinimum) / 2.0
    
    private(set) var showGrid: Bool = true
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
    
    // MARK: Grid
    
    func update(showGrid value: Bool) {
        
        showGrid = value
    }
    
    // MARK: Lattice
    
    func update(lattice value: Double) {
        
        lattice = max(Self.latticeMinimum, min(Self.latticeMaximum, value))
    }
}
