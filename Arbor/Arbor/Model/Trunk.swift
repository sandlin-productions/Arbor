//
//  Tree.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//
import Foundation
import Combine
import simd

class Trunk: ObservableObject {
    @Published var branches: [Branch] = []

    init(width: Float, height: Float) {
        // Initialize the root branch with depth
        let rootBranch = Branch(position: SIMD3<Float>(0.0, 0.0, 0.0), length: height, angle: Float.pi / 2, depth: 5)
        self.branches = [rootBranch]
        print("Trunk initialized with width=\(width), height=\(height)")
        
        rotateTree()
    }
    
    func grow() {
        // Logic to grow the tree (if necessary)
        print("Tree growing...")
    }
    
    func rotateTree() {
        let rotation = rotationMatrix(angle: Float.pi / 2, axis: SIMD3<Float>(0, 1, 0)) // 90 degrees
        for branch in branches {
            let rotatedPosition = rotation * SIMD4<Float>(branch.position, 1.0)
            branch.position = SIMD3<Float>(rotatedPosition.x, rotatedPosition.y, rotatedPosition.z) // Extract x, y, z
        }
    }
}


