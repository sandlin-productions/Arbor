//
//  Leaf.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//

import Foundation

class Leaf {
    var size: Float
    var color: SIMD4<Float>
    var position: SIMD3<Float>
    
    init() {
        self.size = 0.0
        self.color = SIMD4<Float>(0.0, 0.0, 0.0, 1.0)
        self.position = SIMD3<Float>(0.0, 0.0, 0.0)
    }
    
    // Methods for generating and placing leaves
}
