//
//  Tree.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//

// Tree.swift

import Foundation
import Metal

class Tree {
    var rootBranch: Branch
    var width: Float
    var height: Float
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
        self.rootBranch = Branch()
    }
    
    func grow() {
        // Set initial parameters for the root branch
        rootBranch.length = height
        rootBranch.thickness = width
        rootBranch.angle = 0.0
        rootBranch.position = SIMD3<Float>(0.0, 0.0, 0.0)
        
        // Generate child branches recursively
        generateBranches(for: rootBranch)
    }
    
    func generateBuffers(device: MTLDevice) {
        // Generate the buffers for each branch in the tree
        generateBuffersForBranch(rootBranch, device: device) // Pass the 'for' argument
    }
    
    private func generateBranches(for branch: Branch) {
        // Implement your branch generation logic here
        // This is where you define how child branches are created and positioned
        // You can use properties of the parent branch to determine the child branch properties
        
        // For example, you can create two child branches at specific angles:
        
        let leftChild = Branch()
        leftChild.length = branch.length * 0.8
        leftChild.thickness = branch.thickness * 0.7
        leftChild.angle = branch.angle + 45.0
        leftChild.position = branch.position
        
        let rightChild = Branch()
        rightChild.length = branch.length * 0.8
        rightChild.thickness = branch.thickness * 0.7
        rightChild.angle = branch.angle - 45.0
        rightChild.position = branch.position
        
        // Add the child branches to the parent branch's children array
        branch.children.append(leftChild)
        branch.children.append(rightChild)
        
        // Recursively generate branches for the child branches
        for child in branch.children {
            generateBranches(for: child)
        }
    }
    
    private func generateBuffersForBranch(_ branch: Branch, device: MTLDevice) {
        // Generate the buffers for the current branch
        // Use the 'branch' and 'device' arguments as needed
        
        // This is just a placeholder implementation
        print("Generating buffers for branch")
        
        // Generate buffers for child branches recursively
        for child in branch.children {
            generateBuffersForBranch(child, device: device)
        }
    }
}
