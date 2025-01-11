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
    float4 position [[position]]; // Clip-space position for rasterization
};

// Vertex shader function
vertex VertexOutput vertexShader(VertexInput vertexIn [[stage_in]]) {
    VertexOutput vertexOut;
    vertexOut.position = vertexIn.position; // Pass position as-is
    return vertexOut;
}

// Fragment shader function
fragment float4 fragmentShader(VertexOutput vertexOut [[stage_in]]) {
    // Return a brown color for branches
    return float4(0.5, 0.25, 0.0, 1.0); // Brown
}
