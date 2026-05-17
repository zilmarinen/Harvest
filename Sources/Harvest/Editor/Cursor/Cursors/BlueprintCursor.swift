//
//  BlueprintCursor.swift
//  Harvest
//
//  Created by Zack Brown on 17/05/2026.
//

import Deltille
import Euclid
import RealityKit
import Yield

internal class BlueprintCursor: Entity,
                                HasModel {}

extension BlueprintCursor {
    
    internal func set(asset: Asset) {
        
        guard let material = ShaderProgram.shared.material(for: .customMaterial) else { fatalError("Invalid shader program") }
        
        do {
            
            let resource = try AssetCache.shared.load(resource: asset)
            
            self.model = .init(mesh: resource,
                               materials: [material])
        }
        catch {
            
            fatalError("Error loading blueprint asset")
        }
    }
}
