//
//  Camera.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import CoreGraphics
import Foundation

internal class Camera {
    
    internal var position: CGPoint = .zero
    internal var scale: CGFloat = 1.0
}

internal extension Camera {
    
    // MARK: Coordinate Conversion
    
    func worldPoint(fromView point: CGPoint,
                    viewSize: CGSize) -> CGPoint {
        
        CGPoint(x: (point.x - viewSize.width / 2) / scale + position.x,
                y: (point.y - viewSize.height / 2) / scale + position.y)
    }
}
