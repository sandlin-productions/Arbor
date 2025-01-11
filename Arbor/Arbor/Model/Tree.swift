//
//  Tree.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/23/23.
//

import Foundation
import Combine

class Tree: ObservableObject {
    @Published var rootBranch: Branch
    var width: Float
    var height: Float
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
        self.rootBranch = Branch()
        
        print("Tree initialized with width=\(width), height=\(height)")
    }
    
    func grow() {
        // Logic to grow the tree
        print("Tree growing...")
    }
}
