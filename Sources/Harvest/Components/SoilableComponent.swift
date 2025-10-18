//
//  SoilableComponent.swift
//
//  Created by Zack Brown on 07/09/2025.
//

import RealityKit

internal struct SoilableComponent: Component {
    
    internal var isDirty: Bool = true
}

internal protocol HasSoilableComponent: Entity {
    
    var soilableComponent: SoilableComponent { get set }
    
    func becomeDirty()
}

extension HasSoilableComponent {
    
    internal var soilableComponent: SoilableComponent {
        
        get {
            
            let component = components[SoilableComponent.self] ?? .init()
            
            if components[SoilableComponent.self] == nil {
                
                components[SoilableComponent.self] = component
            }
            
            return component
        }
        
        set {
            
            components[SoilableComponent.self] = newValue
        }
    }
    
    internal var isDirty: Bool {
        
        get {
            
            soilableComponent.isDirty
        }
        
        set {
            
            soilableComponent.isDirty = newValue
        }
    }
    
    internal func becomeDirty() {
        
        guard !isDirty else { return }
        
        soilableComponent.isDirty = true
    }
}
