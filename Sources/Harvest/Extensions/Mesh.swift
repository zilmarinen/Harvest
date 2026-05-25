//
//  Mesh.swift
//
//  Created by Zack Brown on 19/10/2025.
//

import Deltille
import Euclid

extension Mesh {
    
    internal static func cursor(_ scale: Triangle.Scale) -> Self {
        
        let triangle = Triangle.zero
        let span = scale.length * 0.5
        let center = triangle.position(scale)
        
        let peak = center + .init(0.0, span, 0.0)
        let base = center - .init(0.0, span, 0.0)
        
        var polygons: [Polygon] = []
        
        for i in triangle.vertices.indices {
            
            let j = (i + 1) % triangle.vertices.count
            
            let v0 = triangle.vertices[i].position(scale)
            let v1 = triangle.vertices[j].position(scale)
            
            let upperFace = [v0, v1, peak, v0]
            let lowerFace = [v0, base, v1, v0]
            
            let upperPoints = upperFace.map {
                
                PathPoint($0,
                          texcoord: nil,
                          color: nil,
                          isCurved: false)
            }
            
            let lowerPoints = lowerFace.map {
                
                PathPoint($0,
                          texcoord: nil,
                          color: nil,
                          isCurved: false)
            }
            
            let upperPath = Path(upperPoints)
            let lowerPath = Path(lowerPoints)
            
            guard let upperPolygon = Polygon(upperPath),
                  let lowerPolygon = Polygon(lowerPath) else { continue }
            
            polygons.append(contentsOf: [upperPolygon,
                                         lowerPolygon])
        }
        
        return Mesh(polygons)
    }
}
