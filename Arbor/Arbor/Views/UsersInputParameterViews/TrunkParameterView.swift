//
//  SliderView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/17/23.
//

import SwiftUI

struct TrunkParameterView: View {
    @State private var value1: Double = 0.5
    @State private var widthValue: Double = 70.0
    @State private var middleWidthValue: Double = 40.0
    @State private var heightValue: Double = 70.0
    
    var body: some View {
        VStack {
            Text("Trunk Parameters").bold()
            Slider(value: $value1, in: 0...1)
                .padding()
            Text("Scale Value: \(value1, specifier: "%.2f")")
            
            Slider(value: $widthValue, in: 0...100)
                .padding()
            Text(" Base Width Value: \(widthValue, specifier: "%.0f")")
            
            Slider(value: $widthValue, in: 0...100)
                .padding()
            Text(" Middle Width Value: \(middleWidthValue, specifier: "%.0f")")
            
            Slider(value: $heightValue, in: 0...100)
                .padding()
            Text("Height Value: \(heightValue, specifier: "%.0f")")
            
            // Add more sliders here as needed
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        TrunkParameterView()
    }
}
