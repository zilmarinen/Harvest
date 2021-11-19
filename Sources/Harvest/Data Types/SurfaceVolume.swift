//
//  SurfaceVolume.swift
//
//  Created by Zack Brown on 16/11/2021.
//

import Meadow

struct SurfaceVolume<T: Codable & Equatable>: Codable, Equatable {
    
    let coordinate: Coordinate
    let sockets: SurfaceSockets<T>
}

