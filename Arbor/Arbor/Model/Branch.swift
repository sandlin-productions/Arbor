//
//  Branch.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//

import Foundation
import Metal
import simd

class Branch {
    var length: Float
    var thickness: Float
    var angle: Float
    var position: SIMD3<Float>
    var parent: Branch?
    var children: [Branch] = []
    
    var vertices: [Vertex] = []
    var indices: [UInt16] = []
    
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var indexCount: Int!
    
    init() {
        self.length = 0.0
        self.thickness = 0.0
        self.angle = 0.0
        self.position = SIMD3<Float>(0.0, 0.0, 0.0)
    }
    
    func grow() {
        // ...
    }
    
    private func generateBranches() {
        // ...
    }
    
    func generateBuffers(device: MTLDevice) {
        // Generate the vertex buffer and index buffer for the branch

        // Define the vertices for a simple line segment
        let startVertex = Vertex(position: SIMD3<Float>(0.0, 0.0, 0.0))
        let endVertex = Vertex(position: SIMD3<Float>(1.0, 1.0, 0.0))

        // Define the indices to connect the vertices as a line
        let startIndex: UInt16 = 0
        let endIndex: UInt16 = 1

        // Assign the vertices and indices to the branch's properties
        vertices = [startVertex, endVertex]
        indices = [startIndex, endIndex]

        // Print the generated vertices and indices
        print("Generated vertices: \(vertices)")
        print("Generated indices: \(indices)")

        // Create the vertex buffer
        let vertexBufferSize = MemoryLayout<Vertex>.stride * vertices.count
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertexBufferSize, options: [])

        // Create the index buffer
        let indexBufferSize = MemoryLayout<UInt16>.stride * indices.count
        indexBuffer = device.makeBuffer(bytes: indices, length: indexBufferSize, options: [])

        // Set the index count
        indexCount = indices.count
    }

    
    func setupBuffers(device: MTLDevice) {
        // Generate the buffers if they haven't been generated yet
        if vertexBuffer == nil || indexBuffer == nil {
            generateBuffers(device: device)
        }
        // Create an index buffer with the indices
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.stride, options: [])
        
        // Set the index count based on the number of indices
        indexCount = indices.count
    }
    
}

// Placeholder definitions for Vertex, vertices, and indices
struct Vertex {
    var position: SIMD3<Float>
}

// Extension for rotation matrix calculation
extension simd_float3x3 {
    static func rotationMatrix(angle: Float) -> simd_float3x3 {
        let radianAngle = angle * .pi / 180.0
        let c = cos(radianAngle)
        let s = sin(radianAngle)
        
        return simd_float3x3([
            simd_float3(c, -s, 0.0),
            simd_float3(s, c, 0.0),
            simd_float3(0.0, 0.0, 1.0)
        ])
    }
}
