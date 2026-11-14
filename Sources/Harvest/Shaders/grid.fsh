//
//  grid.fsh
//  Harvest
//
//  Created by Zack Brown on 12/11/2026.
//

constant float lineWidth = 0.01;
constant float pid4 = 0.7853981634; // pi / 4
constant float sqrt2d3 = 0.4714045208;
constant float sqrt3m1d2 = 0.36602540378;
constant float sqrt3m3d6 = 0.211324865;

float dot2(vec2 v) {
    
    return dot(v, v);
}

float dotClamped(vec3 lhs,
                 vec3 rhs) {
    
    return max(0.0, dot(lhs, rhs));
}

float triangleSDF(vec2 p,
                  vec2 c0,
                  vec2 c1,
                  vec2 c2) {
    
    vec2 p0 = c1 - c0;
    vec2 p1 = c2 - c1;
    vec2 p2 = c0 - c2;
    
    vec2 v0 = p - c0;
    vec2 v1 = p - c1;
    vec2 v2 = p - c2;
    
    float d0 = dot2(v0 - p0 * clamp(dot(v0, p0) / dot2(p0), 0.0, 1.0));
    float d1 = dot2(v1 - p1 * clamp(dot(v1, p1) / dot2(p1), 0.0, 1.0));
    float d2 = dot2(v2 - p2 * clamp(dot(v2, p2) / dot2(p2), 0.0, 1.0));
    
    float o = p0.x * p2.y - p0.y * p2.x;
    
    vec2 d = min(min(vec2(d0, o * (v0.x * p0.y - v0.y * p0.x)),
                     vec2(d1, o * (v1.x * p1.y - v1.y * p1.x))),
                     vec2(d2, o * (v2.x * p2.y - v2.y * p2.x)));
    
    return -sqrt(d.x) * sign(d.y);
}

float world_grid(vec2 worldXZ,
                 float length) {
    
    float c = cos(pid4);
    float s = sin(pid4);
    float scale = 1.0 / length;
    
    vec2 offset = vec2((sqrt2d3 * 2.0) * length, 0.0);
    
    mat2 rotation = mat2(c, -s, s, c);
    
    vec2 position = (rotation * ((worldXZ * sqrt2d3) + offset)) * scale;
    
    vec2 index = floor(position + (position.x + position.y) * sqrt3m1d2);
    vec2 corner = index + (index.x + index.y) * -sqrt3m3d6;
    
    vec2 relative = position - corner;
    
    float side = relative.x > relative.y ? 0.0 : 1.0;
    
    vec2 derivative = vec2(1.0 - side, side);
    
    vec2 c0 = vec2(0.0, 0.0);
    vec2 c2 = derivative + vec2(-sqrt3m3d6);
    vec2 c1 = vec2(1.0) + 2.0 * -sqrt3m3d6;
    
    float sdf = triangleSDF(relative, c0, c1, c2) * length / lineWidth;
    
    float outline = abs(sdf) - 0.5;
    
    return 1.0 - smoothstep(-0.5,
                            0.5,
                            outline);
}

void main() {
    
    float grid = world_grid(gl_FragCoord.xy, lattice);
    
    vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 background = vec4(1.0, 1.0, 1.0, 1.0);
    
    gl_FragColor = mix(background, black, grid);
}
