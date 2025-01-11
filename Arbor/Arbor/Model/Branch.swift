//
//  Branch.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//

import Foundation

class Branch {
    var position: float3
    var length: Float
    var angle: Float
    var children: [Branch]

    init(position: float3, length: Float, angle: Float, depth: Int) {
        self.position = position
        self.length = length
        self.angle = angle
        self.children = []

        // Stop recursion when depth reaches 0
        guard depth > 0 else { return }

        // Generate two child branches at different angles
        let leftChild = Branch(
            position: calculateEndPosition(),
            length: length * 0.7, // Reduce length for child branches
            angle: angle + .pi / 6, // Rotate 30° clockwise
            depth: depth - 1
        )
        let rightChild = Branch(
            position: calculateEndPosition(),
            length: length * 0.7, // Reduce length for child branches
            angle: angle - .pi / 6, // Rotate 30° counterclockwise
            depth: depth - 1
        )

        self.children = [leftChild, rightChild]
    }

    // Helper function to calculate the end position of this branch
    func calculateEndPosition() -> float3 {
        return float3(
            position.x + length * cos(angle),
            position.y + length * sin(angle),
            position.z
        )
    }
}
