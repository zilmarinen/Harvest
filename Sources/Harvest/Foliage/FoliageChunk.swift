//
//  FoliageChunk.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public final class FoliageChunk: GraphChunk<FoliageTile>,
                                 Soilable {
    
    internal var isDirty: Bool = false
    
    internal var region: FoliageRegion? { parent as? FoliageRegion }
}

extension FoliageChunk {
    
    func becomeDirty() {
        
        guard !isDirty else { return }
        
        isDirty = true
        
        region?.becomeDirty()
    }
}
