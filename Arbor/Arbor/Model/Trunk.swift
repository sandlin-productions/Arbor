//
//  Tree.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//

import Foundation
import Combine

class Trunk: ObservableObject {
    @Published var branches: [Branch] = []

    init(width: Float, height: Float) {
        // Initialize the root branch with depth
        let rootBranch = Branch(position: SIMD3<Float>(0.0, 0.0, 0.0), length: height, angle: 0.0, depth: 5)
        self.branches = [rootBranch]
        print("Trunk initialized with width=\(width), height=\(height)")
    }
    
    func grow() {
        // Logic to grow the tree (if necessary)
        print("Tree growing...")
    }
}




