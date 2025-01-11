//
//  SliderView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/17/23.
//

import SwiftUI

struct TrunkParameterView: View {
    @ObservedObject var trunk: Trunk
    
    var body: some View {
        VStack {
            Text("Trunk Parameters").bold()
            
            Slider(value: Binding(
                get: { Double(trunk.branches.first?.length ?? 0.0) },
                set: { newValue in trunk.branches.first?.length = Float(newValue) }
            ), in: 0...100)
            .padding()
            Text("Height Value: \(trunk.branches.first?.length ?? 0.0, specifier: "%.0f")")
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct TrunkSliderView_Previews: PreviewProvider {
    static var previews: some View {
        let mockTrunk = Trunk(width: 10, height: 20) // Provide mock data
        TrunkParameterView(trunk: mockTrunk)
    }
}
