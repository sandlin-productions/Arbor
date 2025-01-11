//
//  Branch.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//

import Foundation

class Branch {
    var length: Float
    var thickness: Float
    var angle: Float
    var position: SIMD3<Float>
    var parent: Branch?
    var children: [Branch] = []
    
    init() {
        self.length = 10.0 // Sample value for debugging
        self.thickness = 2.0 // Sample value for debugging
        self.angle = 0.0
        self.position = SIMD3<Float>(0.0, 0.0, 0.0)
        print("Branch initialized with length=\(length), thickness=\(thickness), angle=\(angle)")
    }
    
    func grow() {
        // Logic to grow the branch
        print("Branch growing...")
    }
}
