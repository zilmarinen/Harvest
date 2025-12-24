//
//  CustomMaterial.metal
//
//  Created by Zack Brown on 08/10/2025.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
#include <simd/simd.h>

using namespace metal;
using namespace realitykit;

constant float sqrt3 = 1.7320508076;

[[visible]]
void customMaterialGeometry(geometry_parameters params) {
    
    //
}

[[visible]]
void customMaterialSurface(surface_parameters params) {
    
    float4 baseColor = params.geometry().color();
    
    float scale = 0.5;
    float lineWidth = 0.01;
    float4 lineColor = float4(0.0, 0.0, 0.0, 1.0);
    float2x2 matrix = float2x2(0.0, 2.0 / sqrt3, 1.0, -1.0 / sqrt3);
    
    // Project world position onto XZ plane
    float2 position = (params.geometry().world_position().xz * scale) * matrix;
    
    // Convert to hexagonal coordinates
    float3 hexagonal = fract(float3(position, 1.0 - position.x - position.y));
    
//    if (length(hexagonal) > 1.0) {
//        
//        hexagonal = 1.0 - hexagonal;
//    }
    
    float grid = min(min(smoothstep(0.0, lineWidth, hexagonal.x),
                         smoothstep(0.0, lineWidth, hexagonal.y)),
                         smoothstep(0.0, lineWidth, hexagonal.z));
    
    float4 color = baseColor;// mix(lineColor, baseColor, grid);
    
    /*
     
     vec2 R = iResolution.xy,
              U = uv = (uv-R/2.)/R.y;               // centered coords
         
         U *= mat2(1,-1./1.73, 0,2./1.73) *5.;      // conversion to
         vec3 g = vec3(U,1.-U.x-U.y);                // hexagonal coordinates

         g = fract(g);                              // diamond coords
         if (length(g)>1.) g = 1.-g;                // barycentric coords
         vec3 g2 = abs(2.*fract(g)-1.);             // distance to borders
         
         float step = min(min(smoothstep(0.0, 0.01, g.r),
                              smoothstep(0.0, 0.01, g.g)),
                              smoothstep(0.0, 0.01, g.b));
         
         O = vec4(mix(vec3(0.0), vec3(1.0), step), 1.0);
     
     */
    
    params.surface().set_base_color(half3(color.xyz));
}

//
//
//

[[visible]]
void waterGeometry(geometry_parameters params) {
    
    //
}

[[visible]]
void waterSurface(surface_parameters params) {
    
    float4 baseColor = params.geometry().color();
    
    params.surface().set_base_color(half3(baseColor.xyz));
    params.surface().set_opacity(0.5);
}

//
//
//

[[visible]]
void sobelGeometry(geometry_parameters params) {
    
    //
}

[[visible]]
void sobelSurface(surface_parameters params) {
    
    float4 baseColor = params.geometry().color();
    
    params.surface().set_base_color(half3(baseColor.xyz));
    params.surface().set_opacity(0.5);
}

