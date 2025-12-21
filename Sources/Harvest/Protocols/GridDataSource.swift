//
//  GridDataSource.swift
//
//  Created by Zack Brown on 20/12/2025.
//

import Deltille
import RealityKit

internal protocol GridDataSource: Entity {
    
    associatedtype C
    associatedtype K
    associatedtype S
    associatedtype V
    
    func merge(_ chunks: [C])
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
    
    func slice(for sieve: Triangle.Sieve) -> S
}
