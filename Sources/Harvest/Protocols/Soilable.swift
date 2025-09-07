//
//  Soilable.swift
//  Harvest
//
//  Created by Zack Brown on 04/09/2025.
//

import RealityKit

internal protocol Soilable: AnyObject {
    
    var isDirty: Bool { get set }
    
    func becomeDirty()
}

extension Soilable {
    
    func becomeDirty() {
        
        guard !isDirty else { return }
        
        isDirty = true
    }
}
