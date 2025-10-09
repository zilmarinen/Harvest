//
//  CustomMaterial.metal
//  Harvest
//
//  Created by Zack Brown on 08/10/2025.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
#include <simd/simd.h>

using namespace metal;
using namespace realitykit;

[[visible]]
void customMaterialGeometry(geometry_parameters params) {
    
    //
}

[[visible]]
void customMaterialSurface(surface_parameters params) {
    
    float4 baseColor = params.geometry().color();
    
    float scale = 1.0;
    float lineWidth = 0.01;
    float4 lineColor = float4(0.0, 0.0, 0.0, 1.0);
    
    // Project world position onto XZ plane
    float2 pos = params.geometry().world_position().xz * scale;

    // Parameters for equilateral triangles
    float s = sqrt(3.0);
    float triH = s / 2.0; // triangle height

    // Convert world XZ into "tri grid" coordinates
    float2 grid = pos / float2(1.0, triH);
    float2 cell = floor(grid);
    float2 f = fract(grid);

    // Flip every other row for axis alignment
    bool flip = fmod(cell.y, 2.0) < 1.0;
    
    if (flip) {
      
        f.x = 1.0 - f.x;
    }

    // Compute distance to nearest triangle edge
    float2 a = float2(0.5, 0.0);
    float2 b = float2(0.0, triH);
    float2 c = float2(1.0, triH);

    // Barycentric coordinates for distance calculation
    float2 p2 = f * float2(1.0, triH);
    float2 ab = b - a;
    float2 bc = c - b;
    float2 ca = a - c;

    // Signed distances to edges
    float da = dot(normalize(float2(ab.y, -ab.x)), p2 - a);
    float db = dot(normalize(float2(bc.y, -bc.x)), p2 - b);
    float dc = dot(normalize(float2(ca.y, -ca.x)), p2 - c);

    float edgeDist = min(min(abs(da), abs(db)), abs(dc));

    // Smooth line mask
    float lineMask = smoothstep(lineWidth, lineWidth * 0.5, edgeDist);

    float4 color = mix(baseColor, lineColor, lineMask);

    //params.surface().set_base_color(half3(color.xyz));
    params.surface().set_base_color(half3(baseColor.xyz));
}
