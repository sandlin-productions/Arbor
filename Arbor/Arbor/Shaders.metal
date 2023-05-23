//
//  Shaders.metal
//  Arbor
//
//  Created by Stephen Sandlin on 5/21/23.
//

#include <metal_stdlib>

using namespace metal;

// Vertex input struct
struct VertexInput {
    float4 position [[attribute(0)]];
};

// Vertex output struct
struct VertexOutput {
    float4 position [[position]];
};

// Vertex shader function
vertex VertexOutput vertexShader(VertexInput vertexIn [[stage_in]]) {
    VertexOutput vertexOut;
    vertexOut.position = vertexIn.position;
    
    return vertexOut;
}

// Fragment shader function
fragment float4 fragmentShader(VertexOutput vertexOut [[stage_in]]) {
    float4 color = float4(0.0, 1.0, 0.0, 1.0); // Red color
    
    return color;
}
