//
//  SKShader.swift
//
//  Created by Zack Brown on 02/04/2021.
//

import SpriteKit

extension SKShader {
    
    enum Shader: String {
        
        case graph = "Graph2D"
        case grid = "Grid2D"
        case surface = "Surface2D"
    }
    
    convenience init(shader: Shader) {
        
        guard let path = Bundle.module.path(forResource: shader.rawValue, ofType: "fsh"),
              let source = try? String(contentsOfFile: path) else { fatalError("Unabled to load \(shader.rawValue) shader") }
        
        self.init(source: source)
    }
}
