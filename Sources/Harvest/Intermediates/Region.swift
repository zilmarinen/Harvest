//
//  RegionSlice.swift
//
//  Created by Zack Brown on 13/09/2025.
//

import Deltille
import Lattice

public struct RegionSlice: Codable,
                           Equatable,
                           Hashable {

    public let vertex: Triangle.Vertex
    
    public let buildings: TriangularLatticeSlice<BuildingChunk, BuildingTile>?
    public let fences: HexagonalLatticeSlice<FenceChunk, FenceVertex>?
    public let foliage: HexagonalLatticeSlice<FoliageChunk, FoliageVertex>?
    public let footpaths: HexagonalLatticeSlice<FootpathChunk, FootpathVertex>?
    public let portals: TriangularLatticeSlice<PortalChunk, PortalTile>?
    public let slopes: TriangularLatticeSlice<SlopeChunk, SlopeTile>?
    public let terrain: HexagonalLatticeSlice<TerrainChunk, TerrainVertex>?
    public let water: TriangularLatticeSlice<WaterChunk, WaterTile>?
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(vertex)
    }
    
    public static func == (lhs: RegionSlice,
                           rhs: RegionSlice) -> Bool {
        
        lhs.vertex == rhs.vertex
    }
}

extension RegionSlice {
    
    public var isEmpty: Bool {
        
        (terrain?.isEmpty ?? true) &&
        (water?.isEmpty ?? true)
    }
}

extension RegionSlice {
    
    @MainActor
    public func remove(values sieve: Triangle.Sieve) {
        
        let triangles = sieve.triangles
        let vertices = sieve.vertices
        
        buildings?.remove(values: triangles)
        fences?.remove(values: vertices)
        foliage?.remove(values: vertices)
        footpaths?.remove(values: vertices)
        portals?.remove(values: triangles)
        slopes?.remove(values: triangles)
        terrain?.remove(values: vertices)
        water?.remove(values: triangles)
    }
}

extension RegionSlice {
    
    public init(empty triangle: Triangle) {
        
        self.init(vertex: triangle.vertex,
                  buildings: nil,
                  fences: nil,
                  foliage: nil,
                  footpaths: nil,
                  portals: nil,
                  slopes: nil,
                  terrain: nil,
                  water: nil)
    }
}
