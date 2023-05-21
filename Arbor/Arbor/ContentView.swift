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
    
    var body: some View {
        NavigationView {
            NavigationStack {
                List {
                    ForEach(1..<6) { index in
                        NavigationLink(
                            destination: destinationForTab(index),
                            tag: index,
                            selection: $selectedTab,
                            label: {
                                labelForTab(index)
                            }
                        )
                    }
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 150, maxWidth: 200)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            //Divider() This makes the 3 colum look I want, but I need to figure how to make it work better
            
            TreeVisualizationView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) { // <-- Change placement to .primaryAction
                Button(action: {
                    isInspectorVisible.toggle()
                }) {
                    Image(systemName: isInspectorVisible ? "sidebar.left" : "sidebar.right")
                }
            }
        }
        .frame(minWidth: 1000, minHeight: 600)
    }
    
    func destinationForTab(_ tab: Int) -> some View {
            switch tab {
            case 1:
                return AnyView(OverviewParameterView())
            case 2:
                return AnyView(TrunkParameterView())
            case 3:
                return AnyView(BranchParameterView())
            case 4:
                return AnyView(LeafParameterView())
            case 5:
                return AnyView(MeshParameterView())
            default:
                return AnyView(OverviewParameterView())
            }
        }
    
    func labelForTab(_ tab: Int) -> some View {
        switch tab {
        case 1:
            return Label("Overview", systemImage: "doc.text.magnifyingglass")
        case 2:
            return Label("Trunk", systemImage: "arrow.up.forward")
        case 3:
            return Label("Branch", systemImage: "arrow.branch")
        case 4:
            return Label("Leaf", systemImage: "leaf")
        case 5:
            return Label("Mesh", systemImage: "square.grid.2x2")
        default:
            return Label("Overview", systemImage: "doc.text.magnifyingglass")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
