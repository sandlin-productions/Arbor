//
//  TreeVisualizationView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/17/23.
//

import SwiftUI
import MetalKit

typealias float4 = SIMD4<Float>
typealias float3 = SIMD3<Float>

struct TreeVisualizationView: NSViewRepresentable {
    typealias NSViewType = MTKView
    
    @ObservedObject var tree: Trunk // Observed tree object for dynamic updates

    func makeNSView(context: Context) -> MTKView {
        let metalDevice = MTLCreateSystemDefaultDevice()
        let metalView = MTKView(frame: .zero, device: metalDevice)
        metalView.delegate = context.coordinator
        return metalView
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        // Update the tree visualization when the tree changes
        print("Updating TreeVisualizationView with new tree data")
        context.coordinator.updateTree(tree)
    }

    func makeCoordinator() -> MetalRenderer {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        let metalView = MTKView(frame: .zero, device: metalDevice)
        return MetalRenderer(metalView: metalView, tree: tree)
    }
}

struct TreeVisualizationView_Previews: PreviewProvider {
    static var previews: some View {
        TreeVisualizationView(tree: Trunk(width: 10, height: 20)) // Pass a sample tree
    }
}


import MetalKit

class MetalRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let renderPipelineState: MTLRenderPipelineState
    let vertexDescriptor: MTLVertexDescriptor

    var vertexBuffer: MTLBuffer?
    var tree: Trunk

    init(metalView: MTKView, tree: Trunk) {
        self.tree = tree

        device = metalView.device!
        commandQueue = device.makeCommandQueue()!

        // Load the Metal library containing the compiled shaders
        guard let defaultLibrary = device.makeDefaultLibrary() else {
            fatalError("Failed to load Metal library")
        }

        // Create a vertex descriptor
        vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float4
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<float4>.stride
        vertexDescriptor.layouts[0].stepRate = 1
        vertexDescriptor.layouts[0].stepFunction = .perVertex

        // Create a render pipeline state using your shaders
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexDescriptor = vertexDescriptor

        renderPipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)

        super.init()

        // Generate vertex buffer from the tree object
        updateTree(tree)
    }

    func updateTree(_ tree: Trunk) {
        // Generate vertex data from the tree
        var vertices: [float4] = []

        // Add the root branch and all its children
        func processBranch(branch: Branch, vertices: inout [float4]) {
            let scale: Float = 0.05 // Adjust this scale factor as needed

            let startPosition = branch.position * scale
            let endPosition = float3(
                startPosition.x + branch.length * cos(branch.angle) * scale,
                startPosition.y + branch.length * sin(branch.angle) * scale,
                startPosition.z
            )
            // Debugging : Print out the angle for each branch
            print("Branch Angle: \(branch.angle)")
            
            let thickness: Float = 0.08 // Thin out the branches
            let perpendicular = float3(-sin(branch.angle), cos(branch.angle), 0.0) * thickness / 2.0

            let start1 = startPosition - perpendicular
            let start2 = startPosition + perpendicular
            let end1 = endPosition - perpendicular
            let end2 = endPosition + perpendicular
            
            //Append vertices to represnet the branch
            vertices.append(float4(start1, 1.0))
            vertices.append(float4(start2, 1.0))
            vertices.append(float4(end1, 1.0))
            vertices.append(float4(end2, 1.0))
            
            // Debugging: Check if child branches exist
                    if branch.children.isEmpty {
                        print("No children for this branch")
                    } else {
                        print("Processing \(branch.children.count) child branches")
                    }

                    // Recursively process child branches
                    for child in branch.children {
                        processBranch(branch: child, vertices: &vertices)
                    }
                }

                // Safely unwrap the root branch
                if let rootBranch = tree.branches.first {
                    processBranch(branch: rootBranch, vertices: &vertices)
                }

                // Debugging: Print vertex positions
                print("Vertex positions:")
                for vertex in vertices {
                    print(vertex)
                }

                // Debugging: Print total vertices count
                print("Total vertices count: \(vertices.count)")

                // Create a Metal buffer for the vertices
                vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<float4>.stride, options: [])
    }
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle resizing if needed
    }

    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("Failed to create command buffer")
            return
        }

        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            print("Failed to obtain render pass descriptor")
            return
        }

        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            print("Failed to create render command encoder")
            return
        }

        // Ensure vertexBuffer is valid
        if let vertexBuffer = vertexBuffer {
            let vertexCount = vertexBuffer.length / MemoryLayout<float4>.stride
            print("Drawing \(vertexCount) vertices")
        } else {
            print("Vertex buffer is nil")
        }

        renderEncoder.setRenderPipelineState(renderPipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

        // Draw the tree as a line strip
        if let vertexBuffer = vertexBuffer {
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.setRenderPipelineState(renderPipelineState)
            renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexBuffer.length / MemoryLayout<float4>.stride)
        }

        renderEncoder.endEncoding()

        guard let drawable = view.currentDrawable else {
            print("Failed to obtain drawable")
            commandBuffer.commit()
            return
        }

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
