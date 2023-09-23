//
//  TerrainChunk.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Bivouac
import SceneKit

public final class TerrainChunk: DualChunk,
                                 Soilable {
    
    internal var isDirty: Bool = false
    
    internal var region: TerrainRegion? { parent as? TerrainRegion }
    internal var heightMap: TerrainHeightMap? { region?.heightMap }
}

extension TerrainChunk {
    
    func becomeDirty() {
        
        guard !isDirty else { return }
        
        isDirty = true
        
        region?.becomeDirty()
    }
}
