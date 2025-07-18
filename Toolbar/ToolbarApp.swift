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
        .defaultSize(width: 500, height: 400)
        .windowStyle(.hiddenTitleBar)
        
        Settings{
            SettingsView()
        }
    }

}

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gearshape.fill") {
                GeneralSettingsView()
            }
            Tab("Recording", systemImage: "record.circle.fill") {
                GeneralSettingsView()
            }
            Tab("Camera", systemImage: "camera.fill") {
                GeneralSettingsView()
            }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0


    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            Slider(value: $fontSize, in: 9...96) {
                Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
            }
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
