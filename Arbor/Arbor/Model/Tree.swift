//
//  Tree.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//

import Foundation

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
        // Logic to grow the tree
    }
    
    // Other methods for updating tree properties, etc.
}
