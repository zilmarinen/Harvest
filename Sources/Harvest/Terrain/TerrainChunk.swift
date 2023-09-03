//
//  TerrainChunk.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Bivouac
import SceneKit

public final class TerrainChunk: DualChunk {
    
    private var region: TerrainRegion? { parent as? TerrainRegion }
    internal var heightMap: TerrainHeightMap? { region?.heightMap }
}
