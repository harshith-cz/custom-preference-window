//
//  PreferenceWindow.swift
//  Toolbar
//
//  Created by Harshith on 17/07/25.
//

import SwiftUI

@Observable
class SettingsModel {
    var selectedTab: SettingsTab = .general
}

enum SettingsTab: String, CaseIterable, Identifiable {
    case general = "General"
    case recording = "Recording"
    case camera = "Camera"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .general: return "gearshape.fill"
        case .recording: return "record.circle.fill"
        case .camera: return "camera.fill"
        }
    }
}

struct SettingsWindow: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        VStack(spacing: 0) {
            ExtendedTitleBarView()
            
            ContentView()
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct ExtendedTitleBarView: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        VStack(spacing: 0) {
            WindowTitleArea()
            
            TabSelectionArea()
        }
        .background(.regularMaterial, in: Rectangle())
        .overlay(
            Rectangle()
                .fill(Color(NSColor.separatorColor))
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
}

struct WindowTitleArea: View {
    var body: some View {
        HStack {
            TrafficLights()
            
            Spacer()
            
            Text("Preferences")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.primary)
            
            Spacer()
            
            HStack(spacing: 12) {
                Spacer().frame(width: 60)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 11)
        .frame(height: 40)
    }
}

struct TrafficLights: View {
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(.red)
                .frame(width: 12, height: 12)
            
            Circle()
                .fill(.yellow)
                .frame(width: 12, height: 12)
            
            Circle()
                .fill(.green)
                .frame(width: 12, height: 12)
        }
    }
}

struct TabSelectionArea: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(SettingsTab.allCases) { tab in
                TabButton(
                    tab: tab,
                    isSelected: settings.selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        settings.selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
    }
}

struct TabButton: View {
    let tab: SettingsTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.2))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(isSelected ? .white : .secondary)
                    )
                
                Text(tab.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
        }
        .buttonStyle(.plain)
        .help("\(tab.rawValue) Settings")
    }
}

struct ContentView: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        Group {
            switch settings.selectedTab {
            case .general:
                GeneralSettingsView()
            case .recording:
                RecordingSettingsView()
            case .camera:
                CameraSettingsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.textBackgroundColor))
    }
}

struct GeneralSettingsView: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("General Settings")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Configure general application preferences and behaviors.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct RecordingSettingsView: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recording Settings")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Adjust video and audio recording parameters.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct CameraSettingsView: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Camera Settings")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Configure camera overlay and positioning options.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
