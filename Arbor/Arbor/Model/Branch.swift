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
        self.length = 0.0
        self.thickness = 0.0
        self.angle = 0.0
        self.position = SIMD3<Float>(0.0, 0.0, 0.0)
    }
    
    func grow() {
        // Logic to grow the branch
    }
    
    // Other methods for creating child branches, etc.
}
