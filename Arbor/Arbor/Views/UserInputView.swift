//
//  UserInputView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/17/23.
//

//  UserInputView.swift
import SwiftUI

struct UserInputView: View {
    var body: some View {
            TabView {
                OverviewView()
                    .tabItem {
                        Label("Overview", systemImage: "info.circle")
                    }
                
                TrunkView()
                    .tabItem {
                        Label("Trunk", systemImage: "square.stack.3d.up.fill")
                    }
                
                BranchView()
                    .tabItem {
                        Label("Branch", systemImage: "arrow.branch")
                    }
                
                LeafView()
                    .tabItem {
                        Label("Leaf", systemImage: "leaf.fill")
                    }
                
                MeshView()
                    .tabItem {
                        Label("Mesh", systemImage: "network")
                    }
            }
        }
    }
    
    struct OverviewView: View {
        var body: some View {
            OverviewParameterView()
        }
    }
    
    struct TrunkView: View {
        var body: some View {
            TrunkParameterView()
        }
    }
    
struct BranchView: View {
    @State private var length: Double = 0.5
    @State private var thickness: Double = 0.7
    @State private var angle: Double = 0.5
    
    var body: some View {
        BranchParameterView(length: $length, thickness: $thickness, angle: $angle)
    }
}

    
    struct LeafView: View {
        var body: some View {
            LeafParameterView()
        }
    }
    
    struct MeshView: View {
        var body: some View {
            MeshParameterView()
        }
    }
    struct UserInputView_Previews: PreviewProvider {
        static var previews: some View {
            UserInputView()
        }
    }
