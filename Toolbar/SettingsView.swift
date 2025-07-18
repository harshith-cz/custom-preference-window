//
//  SettingsView.swift
//  Toolbar
//
//  Created by Harshith on 18/07/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gearshape.fill") {
                GeneralPreference()
            }
            
            Tab("Recording", systemImage: "rectangle.dashed.badge.record") {
                RecordingPreference()
            }
            
            Tab("Camera", systemImage: "video") {
                CameraPreference()
            }
        }
        .background(.ultraThinMaterial)
    }
}

struct GeneralSettingsView: View {
    @State private var onClicked: Bool = false
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0


    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            cropButton
        }
    }
    
    private var cropButton: some View {
        ToolbarActionButton(
            title: "Hello",
            systemImage: "gearshape.fill",
            action: {
                print("Hello world")
            }
        )
    }
}

struct ToolbarActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    @State private var didHover: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21, height: 16)
                
                Text(title)
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(didHover ? .secondary.opacity(0.2) : Color.clear)
        .cornerRadius(4)
        .onHover { didHover = $0 }
    }
}


#Preview {
    SettingsView()
}
