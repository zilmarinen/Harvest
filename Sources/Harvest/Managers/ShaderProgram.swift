//
//  ShaderProgram.swift
//
//  Created by Zack Brown on 05/11/2025.
//

import AppKit
import RealityKit

@MainActor
internal final class ShaderProgram {
    
    internal enum Constant {
        
        static let geometryModifier = "Geometry"
        static let surfaceShader = "Surface"
    }
    
    internal enum Program: String,
                           Identifiable {
        
        case customMaterial
        case grid
        case sobel
        case water
        
        internal var id: String { rawValue }
    }
    
    internal static let shared = ShaderProgram()
    
    private let device: MTLDevice
    private let library: MTLLibrary
    
    internal var materials: [Program: CustomMaterial] = [:]
    
    internal init() {
        
        do {
            
            guard let device = MTLCreateSystemDefaultDevice() else { throw MTLLibraryError(.internal) }
            
            self.device = device
            self.library = try device.makeDefaultLibrary(bundle: .module)
        }
        catch {
            
            fatalError("Error creating default Metal library: \(error)")
        }
    }
}

extension ShaderProgram {
    
    internal func surfaceShader(for program: Program) -> CustomMaterial.SurfaceShader {
        
        .init(named: program.id + Constant.surfaceShader,
              in: library)
    }
    
    internal func geometryModifier(for program: Program) -> CustomMaterial.GeometryModifier {
        
        .init(named: program.id + Constant.geometryModifier,
              in: library)
    }
    
    internal func material(for program: Program) -> CustomMaterial? {
        
        if let material = materials[program] {
            
            return material
        }
        
        let material = try? CustomMaterial(surfaceShader: surfaceShader(for: program),
                                           geometryModifier: geometryModifier(for: program),
                                           lightingModel: .unlit)
        
        guard let material else { return nil }
        
        materials[program] = material
        
        return material
    }
}
