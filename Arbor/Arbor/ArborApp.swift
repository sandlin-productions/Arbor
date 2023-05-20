//
//  ArborApp.swift
//  Arbor
//
//  Created by Stephen Sandlin on 5/17/23.
//

import SwiftUI

@main
struct ArborApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
