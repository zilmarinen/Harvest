//
//  Soilable.swift
//
//  Created by Zack Brown on 08/09/2023.
//

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
