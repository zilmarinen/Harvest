//
//  CustomMaterial.metal
//
//  Created by Zack Brown on 08/10/2025.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
#include <simd/simd.h>
#include "Harvest.metal"

using namespace metal;
using namespace realitykit;

//
//
//

[[visible]]
void customMaterialGeometry(geometry_parameters params) {
    
    //
}

[[visible]]
void customMaterialSurface(surface_parameters params) {
    
    float4 shaded = gooch(params);
    
    params.surface().set_emissive_color(half3(shaded.xyz));
}

[[visible]]
void terrainGeometry(geometry_parameters params) {
    
    //
}

[[visible]]
void terrainSurface(surface_parameters params) {
    
    float4 shaded = gooch(params);
    //float4 baseColor = params.geometry().color();
    
    float2 xz = params.geometry().world_position().xz;
    
    float tileGrid = world_grid(xz, 1.0);
    
    float4 color = mix(shaded, tileColor, tileGrid);
    
    params.surface().set_emissive_color(half3(color.xyz));
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
    
    params.surface().set_emissive_color(half3(baseColor.xyz));
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




//
//
//


[[visible]]
void gridGeometry(geometry_parameters params) {
    
    //
}

[[visible]]
void gridSurface(surface_parameters params) {
 
    float4 baseColor = params.geometry().color();
    
    float2 xz = params.geometry().world_position().xz;
    
    float tileGrid = world_grid(xz, 1.0);
    float chunkGrid = world_grid(xz, 7.0);
    float regionGrid = world_grid(xz, 28.0);
    
    float4 color = mix(baseColor, tileColor, tileGrid);
    color = mix(color, chunkColor, chunkGrid);
    color = mix(color, regionColor, regionGrid);
    
    params.surface().set_emissive_color(half3(color.xyz));
}


//
//  Kernal
//

[[kernel]]
void depthKernel(uint2 gid [[thread_position_in_grid]],
                 texture2d<half, access::sample> inColor [[texture(0)]],
                 texture2d<float, access::sample> inDepth [[texture(1)]],
                 texture2d<half, access::write> outColor [[texture(2)]]) {
    
}
