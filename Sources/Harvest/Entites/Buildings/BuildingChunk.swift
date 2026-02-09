//
//  BuildingChunk.swift
//
//  Created by Zack Brown on 10/11/2025.
//

import Deltille
import Euclid
import RealityKit

internal class BuildingChunk: TriangularChunk,
                              HasMesh {
      
      internal var mesh: Mesh? {
          
          didSet {
              
              updateModel()
          }
      }
      
      internal var material: CustomMaterial? { ShaderProgram.shared.material(for: .customMaterial) }
  }
