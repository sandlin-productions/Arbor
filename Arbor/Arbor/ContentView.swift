//
//  ContentView.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/17/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isInspectorVisible = true
    @State private var isSidebarVisible = true // Added variable to control sidebar visibility
    @State private var selectedTab: Int? = 1 // Default to "Overview"
    @StateObject private var tree = Tree(width: 10, height: 20) // Create an observable Tree object


    var body: some View {
        NavigationSplitView {
            // Sidebar with Navigation Links
                List(selection: $selectedTab) {
                    NavigationLink(value: 1) {
                        Label("Overview", systemImage: "doc.text.magnifyingglass")
                    }
                    NavigationLink(value: 2) {
                        Label("Trunk", systemImage: "arrow.up.forward")
                    }
                    NavigationLink(value: 3) {
                        Label("Branch", systemImage: "arrow.branch")
                    }
                    NavigationLink(value: 4) {
                        Label("Leaf", systemImage: "leaf")
                    }
                    NavigationLink(value: 5) {
                        Label("Mesh", systemImage: "square.grid.2x2")
                    }
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 100, maxWidth: 150)

        } detail: {
            // Middle Section with TreeVisualizationView
            HStack(spacing: 0) {
                TreeVisualizationView(tree: tree)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))// Optional background for clarity
                
                Divider()// Divider between TreeVisualization and Inspector
                
                // Right Section with Parameter View
                if isInspectorVisible {
                    VStack(spacing: 0) {
                        switch selectedTab {
                        case 1:
                            OverviewParameterView()
                        case 2:
                            TrunkParameterView()
                        case 3:
                            BranchParameterView()
                        case 4:
                            LeafParameterView()
                        case 5:
                            MeshParameterView()
                        default:
                            OverviewParameterView()
                        }
                    }
                    .frame(minWidth: 75, maxWidth: 150)
                }
            }
        }
        .toolbar {
            // Toggle button for the inspector on the right
            ToolbarItem(placement: .primaryAction) { // Use .primaryAction for right-side placement
                Button(action: {
                    isInspectorVisible.toggle()
                }) {
                    Image(systemName: isInspectorVisible ? "sidebar.right" : "sidebar.left")
                }
            }
        }
        .frame(minWidth: 800, idealWidth: 900, minHeight: 600, idealHeight: 800)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
