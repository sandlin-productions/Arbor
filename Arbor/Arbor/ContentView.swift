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
    @State private var selectedTab: Int? = nil
    
    let myTree = Tree(width: 10.0, height: 100.0)

    
    var body: some View {
        NavigationView {
            List(selection: $selectedTab) {
                NavigationLink(destination: OverviewParameterView(), tag: 1, selection: $selectedTab) {
                                       Label("Overview", systemImage: "doc.text.magnifyingglass")
                                   }
                                   NavigationLink(destination: TrunkParameterView(), tag: 2, selection: $selectedTab) {
                                       Label("Trunk", systemImage: "arrow.up.forward")
                                   }
                                   NavigationLink(destination: BranchParameterView(), tag: 3, selection: $selectedTab) {
                                       Label("Branch", systemImage: "arrow.branch")
                                   }
                                   NavigationLink(destination: LeafParameterView(), tag: 4, selection: $selectedTab) {
                                       Label("Leaf", systemImage: "leaf")
                                   }
                                   NavigationLink(destination: MeshParameterView(), tag: 5, selection: $selectedTab) {
                                       Label("Mesh", systemImage: "square.grid.2x2")
                                   }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 100, maxWidth: 150)
            
            Divider()
            TreeVisualizationView(tree: myTree)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
                }.frame(minWidth: 300, maxWidth: 300)
                
            }
                             
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    isInspectorVisible.toggle()
                }) {
                    Image(systemName: isInspectorVisible ? "sidebar.left" : "sidebar.right")
                }
            }
        }
        .frame(minWidth: 800, idealWidth: 800, minHeight: 600, idealHeight: 800)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
