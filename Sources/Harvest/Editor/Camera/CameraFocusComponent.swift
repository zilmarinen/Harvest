//
//  CameraFocusComponent.swift
//  Harvest
//
//  Created by Zack Brown on 16/08/2025.
//

import Euclid
import RealityKit

public struct CameraFocusComponent: Component {
    
    internal static let forward = simd_normalize(SIMD3<Float>(-1, -1, -1))
    internal static let minimumRadius: Float = 2.0
    internal static let maximumRadius: Float = 75.0
    
    internal var focus: Vector = .zero
}
