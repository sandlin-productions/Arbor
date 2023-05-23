//
//  TreeVisualizationView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/17/23.
//

import SwiftUI
import MetalKit
typealias float4 = SIMD4<Float>
struct TreeVisualizationView: NSViewRepresentable {
    typealias NSViewType = MTKView

    func makeNSView(context: Context) -> MTKView {
        let metalDevice = MTLCreateSystemDefaultDevice()
        let metalView = MTKView(frame: .zero, device: metalDevice)
        metalView.delegate = context.coordinator
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
        return MetalRenderer(metalView: metalView)
    }
}

struct TreeVisualizationView_Previews: PreviewProvider {
    static var previews: some View {
        TreeVisualizationView()
    }
}

class MetalRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let renderPipelineState: MTLRenderPipelineState
    let vertexDescriptor: MTLVertexDescriptor
    
    init(metalView: MTKView) {
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
        // Set other properties as needed for your specific rendering requirements
        
        // Create the render pipeline state
        renderPipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        super.init()
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
        
        // Set the clear color to green
        let clearColor = MTLClearColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].clearColor = clearColor
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            print("Failed to create render command encoder")
            return
        }
        
        renderEncoder.setRenderPipelineState(renderPipelineState)
        // ...
        
        // Add any necessary debugging statements here
        print("Drawing")
        
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
