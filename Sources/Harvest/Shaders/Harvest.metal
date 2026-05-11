//
//  Harvest.metal
//  Harvest
//
//  Created by Zack Brown on 26/02/2026.
//

#ifndef Harvest
#define Harvest

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
#include <simd/simd.h>

using namespace metal;
using namespace realitykit;

//
//  Constants
//

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

constant float3 lightPosition = float3(1.0, 1.0, 1.0);
constant float4 lightColor = float4(0.996, 0.992, 0.874, 1.0);

constant float4 coldColor = float4(0.325, 0.796, 0.953, 1.0);
constant float4 warmColor = float4(1.0, 0.663, 0.353, 1.0);

constant float4 regionColor = float4(0.0509, 0.4509, 0.3019, 1.0);
constant float4 chunkColor = float4(0.949, 0.7294, 0.3215, 1.0);
constant float4 tileColor = float4(0.349, 0.145, 0.098, 1.0);

constant float lineWidth = 0.01;

//
//  Utilities
//

inline float dot2(float2 v) {
    
    return dot(v, v);
}

inline float dotClamped(float3 lhs,
                        float3 rhs) {
    
    return max(0.0, dot(lhs, rhs));
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

//
//  World Grid
//

inline float world_grid(float2 worldXZ,
                        float length) {
    
    float c = cos(pid4);
    float s = sin(pid4);
    float scale = 1.0 / length;
    
    float2 offset = float2((sqrt2d3 * 2.0) * length, 0.0);
    
    float2x2 rotation = float2x2(c, -s, s, c);
    
    float2 position = (rotation * ((worldXZ * sqrt2d3) + offset)) * scale;
    
    float2 index = floor(position + (position.x + position.y) * sqrt3m1d2);
    float2 corner = index + (index.x + index.y) * -sqrt3m3d6;
    
    float2 relative = position - corner;
    
    float side = relative.x > relative.y ? 0.0 : 1.0;
    
    float2 derivative = float2(1.0 - side, side);
    
    float2 c0 = float2(0.0, 0.0);
    float2 c2 = derivative + float2(-sqrt3m3d6);
    float2 c1 = float2(1.0) + 2.0 * -sqrt3m3d6;
    
    float sdf = triangleSDF(relative, c0, c1, c2) * length / lineWidth;
    
    float outline = abs(sdf) - 0.5;
    
    return 1.0 - smoothstep(-0.5,
                            0.5,
                            outline);
}

//
//  Gooch Shading
//

//inline float4 gooch(surface_parameters params) {
//    
//    float3 n = normalize(params.geometry().normal());
//    float3 l = normalize(light);
//    float3 v = normalize(float3(0.0, 0.0, 1.0));
//    
//    float4 baseColor = params.geometry().color();
//    float4 cold = coldColor + 0.75 * baseColor;
//    float4 warm = warmColor + 0.75 * baseColor;
//    
//    float t = (dot(n, l) + 1.0) * 0.5;
//    float4 color = mix(cold, warm, t);
//    
//    return baseColor;
//}
//
//inline float4 ambient(surface_parameters params) {
//    
//    float3 position = normalize(params.geometry().world_position());
//    float3 normal = normalize(params.surface().normal());
//    float3 light = normalize(float3(1.0, 1.0, 1.0));
//    
//    float3 lightDirection = normalize(light - position);
//    
//    float4 baseColor = params.geometry().color();
//    float4 lightColor = float4(1.0, 0.941, 0.745, 1.0);
//    
//    float ambientStrength = 0.1;
//    
//    float4 ambient = ambientStrength * lightColor;
//    float4 diffuse = (dotClamped(normal, lightDirection) * lightColor);
//    
//    return (ambient + diffuse) * baseColor;
//}

inline float4 lambert(surface_parameters params) {
    
    float3 lightDirection = normalize(lightPosition);
    float3 normal = normalize(params.geometry().normal());
    float4 baseColor = params.geometry().color();

    float ndotl = dotClamped( normal, lightDirection);
    return baseColor * lightColor * ndotl;
}

/*
 
 void light() {
     float gooch = (1.0f + dot(LIGHT, NORMAL)) / 2.0;
     gooch *= ATTENUATION;
     
     vec3 kCold = cold.rgb + cold_strength * ALBEDO.rgb;
     vec3 kWarm = warm.rgb + warm_strength * ALBEDO.rgb;
     
     vec3 gooch_diffuse = gooch * kWarm + (1.0 - gooch) * kCold;
     vec3 reflection_dir = reflect(-LIGHT, NORMAL);
     float specular = DotClamped(VIEW, reflection_dir);
     specular = pow(specular, smoothness * 32.0) * 5.0;
     
     DIFFUSE_LIGHT += gooch_diffuse * ATTENUATION;
     SPECULAR_LIGHT += specular * ATTENUATION * LIGHT_COLOR;
 }
 
 */

/*
 
 fragment float4 fragment_main(VertexOut in [[stage_in]]) {
 
         float3 N = normalize(in.normalOS);
         float3 L = normalize(float3(1.0, 1.0, 1.0));
         float3 V = normalize(float3(0.0, 0.0, 1.0));
         
         float3 baseColor = float3(0.6, 0.3, 0.2);
         float3 coolColor = float3(0.0, 0.0, 0.55) + 0.25 * baseColor;
         float3 warmColor = float3(0.55, 0.45, 0.0) + 0.25 * baseColor;
         
         float t = (dot(N, L) + 1.0) * 0.5;
         float3 color = mix(coolColor, warmColor, t);
         
         // Add subtle specular highlight
         float3 R = reflect(-L, N);
         float specular = pow(max(0.0, dot(R, V)), 24.0);
         color += float3(1.0) * specular * 0.5;
         
         return float4(color, 1.0);
     }
 
 */

#endif


