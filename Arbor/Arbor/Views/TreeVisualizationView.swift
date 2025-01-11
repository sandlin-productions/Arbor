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
    
    @ObservedObject var tree: Tree // Observed tree object for dynamic updates

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
        TreeVisualizationView(tree: Tree(width: 10, height: 20)) // Pass a sample tree
    }
}


import MetalKit

class MetalRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let renderPipelineState: MTLRenderPipelineState
    let vertexDescriptor: MTLVertexDescriptor

    var vertexBuffer: MTLBuffer?
    var tree: Tree

    init(metalView: MTKView, tree: Tree) {
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

    func updateTree(_ tree: Tree) {
        // Generate vertex data from the tree
        var vertices: [float4] = []
        
        // Add the root branch and all its children
        func processBranch(_ branch: Branch) {
            let startPosition = branch.position
            let endPosition = float3(
                startPosition.x + branch.length * cos(branch.angle),
                startPosition.y + branch.length * sin(branch.angle),
                startPosition.z
            )
            
            // Add branch as two vertices (start and end points)
            vertices.append(float4(startPosition, 1.0))
            vertices.append(float4(endPosition, 1.0))
            
            print("Branch processed: Start=\(startPosition), End=\(endPosition)") // Debugging output
            
            // Process child branches
            for child in branch.children {
                processBranch(child)
            }
        }
        
        processBranch(tree.rootBranch)
        
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
            renderEncoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: vertexBuffer.length / MemoryLayout<float4>.stride)
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
