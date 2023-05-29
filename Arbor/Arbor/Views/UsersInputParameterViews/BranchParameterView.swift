//
//  BranchSliderView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/18/23.
//
// BranchParameterView.swift
import SwiftUI

struct BranchParameterView: View {
    @Binding var length: Double
    @Binding var thickness: Double
    @Binding var angle: Double
    
    var body: some View {
        VStack {
            Text("Branch Parameters").bold()
            
            Slider(value: $length, in: 0...1)
                .padding()
            Text("Length: \(length, specifier: "%.2f")")
            
            Slider(value: $thickness, in: 0...1)
                .padding()
            Text("Thickness: \(thickness, specifier: "%.2f")")
            
            Slider(value: $angle, in: 0...1)
                .padding()
            Text("Angle: \(angle, specifier: "%.2f")")
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct BranchParameterView_Previews: PreviewProvider {
    static var previews: some View {
        BranchParameterView(length: .constant(0.5), thickness: .constant(0.7), angle: .constant(0.5))
    }
}
