//
//  BranchSliderView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/18/23.
//

import SwiftUI

struct BranchParameterView: View {
    @State private var value1: Double = 0.5
    @State private var value2: Double = 0.7
    
    var body: some View {
        VStack {
            Text("Branch Parameters").bold()
            Slider(value: $value1, in: 0...1)
                .padding()
            Text("Slider 1 Value: \(value1, specifier: "%.2f")")
            
            Slider(value: $value2, in: 0...1)
                .padding()

            Text("Slider 2 Value: \(value2, specifier: "%.2f")")
            
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
struct BranchSliderView_Previews: PreviewProvider {
    static var previews: some View {
        BranchParameterView()
    }
}
