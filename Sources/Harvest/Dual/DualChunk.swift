//
//  DualChunk.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import Euclid
import SceneKit

public class DualChunk: SCNNode {
    
    internal let coordinate: Coordinate
    
    required public init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        
        super.init()
        
        self.position = SCNVector3(coordinate.convert(to: .chunk) - coordinate.convert(from: .chunk, to: .region).convert(to: .region))

        let triangle = Grid.Triangle(coordinate)
        
        let vertices = triangle.vertices(for: .chunk).map { Vertex($0 + Vector(0, 0.01, 0) - Vector(self.position), .up) }
        
        guard let polygon = Polygon(vertices) else { return }
        
        let node = SCNNode()
        
        node.geometry = SCNGeometry(Mesh([polygon]))
        node.geometry?.firstMaterial = SCNMaterial()
        node.geometry?.firstMaterial?.diffuse.contents = coordinate.equalToZero ? NSColor.systemMint : NSColor.systemIndigo
        
        addChildNode(node)
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
