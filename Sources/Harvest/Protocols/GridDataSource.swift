//
//  GridDataSource.swift
//
//  Created by Zack Brown on 20/12/2025.
//

import Deltille
import RealityKit

internal protocol GridDataSource: Entity {
    
    associatedtype C
    associatedtype K: Codable & Hashable
    associatedtype S: GridDataSourceSlice
    associatedtype V: Codable
    
    func merge(_ chunks: [C])
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
    
    func remove(values keys: [K])
    
    func slice(for sieve: Triangle.Sieve) -> S
}

extension GridDataSource {
    
    internal func remove(values keys: [K]) {
     
        keys.forEach {
            
            set(nil,
                for: $0)
        }
    }
}
