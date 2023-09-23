//
//  FoliageRegion.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public final class FoliageRegion: GraphRegion<FoliageChunk, FoliageTile>,
                                  Soilable {
    
    internal var isDirty: Bool = false
    
    internal var foliage: Foliage? { parent as? Foliage }
}

extension FoliageRegion {
    
    func becomeDirty() {
        
        guard !isDirty else { return }
        
        isDirty = true
        
        foliage?.becomeDirty()
    }
}
