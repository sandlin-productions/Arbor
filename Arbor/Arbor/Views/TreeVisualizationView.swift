//
//  TreeVisualizationView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/17/23.
//

//  TreeVisualizationView.swift

import SwiftUI
import MetalKit

typealias float4 = SIMD4<Float>

struct TreeVisualizationView: NSViewRepresentable {
    typealias NSViewType = MTKView
    
    let tree: Tree // Define the tree variable here
    
    func makeNSView(context: Context) -> MTKView {
        let metalDevice = MTLCreateSystemDefaultDevice()!
        let metalView = MTKView(frame: .zero, device: metalDevice)
        metalView.delegate = context.coordinator
        metalView.preferredFramesPerSecond = 120
        metalView.enableSetNeedsDisplay = true
        metalView.clearColor = MTLClearColor(red: 0.0, green: 0.25, blue: 1.0, alpha: 1.0)
        metalView.framebufferOnly = false
     //   metalView.drawableSize = CGSize(width: tree.width, height: tree.height)
        metalView.isPaused = false
        return metalView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        // No updates needed for now
    }
    
    func makeCoordinator() -> MetalRenderer {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        
        let metalView = MTKView(frame: .zero, device: metalDevice)
        let branch = Branch()
        branch.setupBuffers(device: metalDevice)
        
        return MetalRenderer(metalView: metalView, rootBranch: tree.rootBranch, tree: tree)
    }
}


/*struct TreeVisualizationView_Previews: PreviewProvider {
 static var previews: some View {
 TreeVisualizationView(tree: <#T##Tree#>)
 }
 }
 */
class MetalRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let renderPipelineState: MTLRenderPipelineState
    let vertexDescriptor: MTLVertexDescriptor
    
    let vertexFunction: MTLFunction
    let fragmentFunction: MTLFunction
    
    let rootBranch: Branch // Add a property to store the rootBranch
    
    init(metalView: MTKView, rootBranch: Branch, tree: Tree) { // Add a parameter for the rootBranch
        device = metalView.device!
        commandQueue = device.makeCommandQueue()!
        self.rootBranch = rootBranch // Store the rootBranch
        
        // Load the Metal library containing the compiled shaders
        guard let defaultLibrary = device.makeDefaultLibrary() else {
            fatalError("Failed to load Metal library")
        }
        
        // Load the vertex and fragment functions from the library
        guard let vertexFunction = defaultLibrary.makeFunction(name: "vertexShader") else {
            fatalError("Failed to load vertex function")
        }
        self.vertexFunction = vertexFunction
        
        guard let fragmentFunction = defaultLibrary.makeFunction(name: "fragmentShader") else {
            fatalError("Failed to load fragment function")
        }
        self.fragmentFunction = fragmentFunction
        
        // Create a vertex descriptor
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float4
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<float4>.stride
        
        self.vertexDescriptor = vertexDescriptor // Initialize the vertexDescriptor property
        
        // Create a render pipeline state using your shaders
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        // Set other properties as needed for your specific rendering requirements
        
        // Create the render pipeline state
        renderPipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        super.init() // Initialize the superclass after initializing the vertexDescriptor
        
        // Adjust the position values to place the root branch at the desired location
        let scale: Float = 2.0
        let startVertex = Vertex(position: SIMD3<Float>(-0.5 * scale, 0.0, 0.0))
        let endVertex = Vertex(position: SIMD3<Float>(0.5 * scale, 0.0, 0.0))
        
        // Define the indices to connect the vertices as a line
        let startIndex: UInt16 = 0
        let endIndex: UInt16 = 1
        
        // Assign the vertices and indices to the root branch's properties
        rootBranch.vertices = [startVertex, endVertex]
        rootBranch.indices = [startIndex, endIndex]
        
        // Create the vertex buffer
        let vertexBufferSize = MemoryLayout<Vertex>.stride * rootBranch.vertices.count
        rootBranch.vertexBuffer = device.makeBuffer(bytes: rootBranch.vertices, length: vertexBufferSize, options: [])
        
        // Create the index buffer
        let indexBufferSize = MemoryLayout<UInt16>.stride * rootBranch.indices.count
        rootBranch.indexBuffer = device.makeBuffer(bytes: rootBranch.indices, length: indexBufferSize, options: [])
        
        // Set the index count
        rootBranch.indexCount = rootBranch.indices.count
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
       // print("Drawable size will change: \(size)")
        // Handle resizing if needed
    }
    
    func draw(in view: MTKView) {
       // print("Draw in view")
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        
        renderEncoder.setRenderPipelineState(renderPipelineState)
        
        // Call setupBuffers for each branch before rendering
        traverseBranches(rootBranch) { branch in
            branch.setupBuffers(device: device)
        }
        
        // Traverse the tree and render each branch
        traverseBranches(rootBranch) { branch in
            if let indexBuffer = branch.indexBuffer, let indexCount = branch.indexCount {
                renderEncoder.setVertexBuffer(branch.vertexBuffer, offset: 0, index: 0)
                renderEncoder.drawIndexedPrimitives(
                    type: .line,
                    indexCount: indexCount,
                    indexType: .uint16,
                    indexBuffer: indexBuffer,
                    indexBufferOffset: 0
                )
            } else {
                print("Error: indexBuffer is nil")
            }
        }
        
        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            commandBuffer.commit()
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    private func traverseBranches(_ branch: Branch, performAction: (Branch) -> Void) {
        performAction(branch)
        for childBranch in branch.children {
            traverseBranches(childBranch, performAction: performAction)
        }
    }
    
    
}
