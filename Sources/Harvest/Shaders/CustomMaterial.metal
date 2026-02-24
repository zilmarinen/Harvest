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

constant float pi = 3.14159265358979;
constant float pid4 = 0.7853981634; // pi / 4
constant float sqrt2 = 1.4142135624;
constant float sqrt2d3 = 0.4714045208;
constant float sqrt3 = 1.7320508076;
constant float sqrt3d2 = 0.8660254038;
constant float sqrt3d3 = 0.5773502692;
constant float sqrt3d6 = 0.2886751346;

constant float sqrt3m1d2 = 0.36602540378;
constant float sqrt3m3d6 = 0.211324865;

inline float dot2(float2 v) {
    
    return dot(v, v);
}

inline float triangleSDF(float2 p,
                         float2 c0,
                         float2 c1,
                         float2 c2) {
    
    float2 p0 = c1 - c0;
    float2 p1 = c2 - c1;
    float2 p2 = c0 - c2;
    
    float2 v0 = p - c0;
    float2 v1 = p - c1;
    float2 v2 = p - c2;
    
    float d0 = dot2(v0 - p0 * clamp(dot(v0, p0) / dot2(p0), 0.0, 1.0));
    float d1 = dot2(v1 - p1 * clamp(dot(v1, p1) / dot2(p1), 0.0, 1.0));
    float d2 = dot2(v2 - p2 * clamp(dot(v2, p2) / dot2(p2), 0.0, 1.0));
    
    float o = p0.x * p2.y - p0.y * p2.x;
    
    float2 d = min(min(float2(d0, o * (v0.x * p0.y - v0.y * p0.x)),
                       float2(d1, o * (v1.x * p1.y - v1.y * p1.x))),
                   float2(d2, o * (v2.x * p2.y - v2.y * p2.x)));
    
    return -sqrt(d.x) * sign(d.y);
}

inline float world_grid(float2 worldXZ,
                        float scale,
                        float lineWidth) {
    
    float c = cos(pid4);
    float s = sin(pid4);
    
    float2 uv = float2((sqrt2d3 * 2.0), 0.0);
    
    float2x2 rotation = float2x2(c, -s, s, c);
    
    float2 position = (rotation * ((worldXZ * sqrt2d3) + uv)) * scale;
    
    float2 index = floor(position + (position.x + position.y) * sqrt3m1d2);
    float2 corner = index + (index.x + index.y) * -sqrt3m3d6;
    
    float2 relative = position - corner;
    
    float side = relative.x > relative.y ? 0.0 : 1.0;
    
    float2 offset = float2(1.0 - side, side);
    
    float2 c0 = float2(0.0, 0.0);
    float2 c2 = offset + float2(-sqrt3m3d6);
    float2 c1 = float2(1.0) + 2.0 * -sqrt3m3d6;
    
    //
    //
    //
    
    float sdf = triangleSDF(relative, c0, c1, c2) / lineWidth;
    
    float outline = abs(sdf) - 0.5;
    
    return 1.0 - smoothstep(-0.5,
                            0.5,
                            outline);
}

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
    baseColor = float4(0.0, 0.0, 0.0, 1.0);
    float4 regionColor = float4(0.611, 0.835, 1.0, 1.0);
    float4 chunkColor = float4(1.0, 0.439, 0.439, 1.0);
    float4 tileColor = float4(1.0, 0.439, 0.439, 1.0);
    
    float2 uv = params.geometry().world_position().xz;
    
    //float tileGrid = world_grid(uv, 1.0, 0.01);
    //float chunkGrid = world_grid(uv, 2.0, 0.01);
    float regionGrid = world_grid(uv, 1.0, 0.01);
    
//    float4 color = mix(baseColor, chunkColor, chunkGrid);
//    color = mix(color, regionColor, regionGrid);
    
    float4 color = mix(baseColor, regionColor, regionGrid);
    //color = mix(color, chunkColor, chunkGrid);
    //color = mix(color, tileColor, tileGrid);
    
    params.surface().set_base_color(half3(color.xyz));
}
