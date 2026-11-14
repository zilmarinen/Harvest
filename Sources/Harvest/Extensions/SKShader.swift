//
//  SKShader.swift
//  Harvest
//
//  Created by Zack Brown on 12/11/2026.
//

import SpriteKit

internal extension SKShader {
    
    enum Program: String,
                  Identifiable {
        
        static let suffix = "fsh"
        
        case grid
        
        var id: String {
            
            rawValue
        }
    }
    
    convenience init(program: Program,
                     uniforms: [SKUniform]) {
        
        guard let path = Bundle.module.path(forResource: program.id,
                                            ofType: Program.suffix),
              let source = try? String(contentsOfFile: path,
                                       encoding: .utf8) else { fatalError("Invalid shader contents for \(program.id)") }
        
        self.init(source: source,
                  uniforms: uniforms)
    }
}
