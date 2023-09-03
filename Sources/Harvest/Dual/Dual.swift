//
//  Dual.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class Dual<R: DualRegion<C>,
                   C: DualChunk>: SCNNode {
    
    private(set) var regions: [R]
    
    required override public init() {
        
        self.regions = []
        
        super.init()
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func find(region coordinate: Coordinate) -> R? { regions.first { $0.coordinate == coordinate } }
    
    internal func add(tile coordinate: Coordinate) {
        
        let origin = coordinate.convert(from: .tile, to: .region)
        
        let region = find(region: origin) ?? R(coordinate: origin)
        
        guard region.parent == nil else { return }
        
        regions.append(region)
        
        addChildNode(region)
    }
}
