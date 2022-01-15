//
//  SurfaceVolume.swift
//
//  Created by Zack Brown on 27/12/2021.
//

import Meadow

extension SurfaceVolume {
    
    func max(volume: SurfaceVolume) -> SurfaceVolume { rawValue > volume.rawValue ? self : volume }
}
