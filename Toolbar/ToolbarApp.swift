//
//  ToolbarApp.swift
//  Toolbar
//
//  Created by Harshith on 17/07/25.
//

import SwiftUI

@main
struct ToolbarApp: App {
    @State private var settingsModel = SettingsModel()
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environment(settingsModel)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        
        Window("Settings", id: "settings") {
            SettingsWindow()
                .environment(settingsModel)
        }
        .windowResizability(.contentSize)
        .windowToolbarStyle(.unified)
        .windowStyle(.titleBar)
        
        Settings {
            SettingsView()
                .environment(settingsModel)
        }
    }
}

struct MainAppView: View {
    @Environment(SettingsModel.self) private var settingsModel
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack {
            Text("Main Application")
                .font(.largeTitle)
                .padding()
            
            Button("Open Settings") {
                openWindow(id: "settings")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(width: 400, height: 300)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Settings") {
                    openWindow(id: "settings")
                }
            }
        }
    }
}
