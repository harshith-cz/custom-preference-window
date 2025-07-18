//
//  SettingToggleRow.swift
//  Toolbar
//
//  Created by Harshith on 18/07/25.
//

import SwiftUI

// MARK: - Reusable Components

/// A reusable component for a setting row with a toggle switch.
struct SettingToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden() // Hide the default label of the Toggle
                .toggleStyle(SwitchToggleStyle(tint: .orange)) // Customize toggle color
        }
        .padding(.vertical, 8)
        .background(Color.clear) // Ensure background is clear for list styling
    }
}

/// A reusable component for a setting row with a picker/dropdown.
struct SettingPickerRow: View {
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                        .foregroundColor(.white) // Ensure picker text is visible
                }
            }
            .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle for dropdown appearance
            .accentColor(.white) // Color of the dropdown arrow/indicator
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1)) // Subtle background for the picker
            )
        }
        .padding(.vertical, 8)
        .background(Color.clear)
    }
}

/// A reusable component for a setting row displaying a shortcut.
struct SettingShortcutRow: View {
    let title: String
    let shortcut: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(shortcut)
                .foregroundColor(.gray) // Slightly dimmer color for the shortcut text
        }
        .padding(.vertical, 8)
        .background(Color.clear)
    }
}

// MARK: - Main Content View

struct ContentView: View {
    // State variables for the settings
    @State private var recordMicrophone = true
    @State private var recordSystemAudio = true
    @State private var countdownTimerSelection = "3 seconds"
    let countdownOptions = ["1 second", "3 seconds", "5 seconds", "10 seconds"]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.2, blue: 0.3), Color(red: 0.05, green: 0.1, blue: 0.15)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            // Settings content
            List {
                Section {
                    SettingToggleRow(title: "Record Microphone", isOn: $recordMicrophone)
                    SettingToggleRow(title: "Record System Audio", isOn: $recordSystemAudio)
                }

                Section {
                    SettingPickerRow(title: "Countdown timer", selection: $countdownTimerSelection, options: countdownOptions)
                }

                Section {
                    SettingShortcutRow(title: "Start / Stop Recording", shortcut: "⌘ + R")
                    SettingShortcutRow(title: "Pause / Resume Recording", shortcut: "⇧ + ⌘ + R")
                }
            }
            // Apply custom list style and backgr
            .background(Color.clear) // Ensure list background is transparent
            .scrollContentBackground(.hidden) // Hide default scroll view background
        }
    }
}

// MARK: - Preview Provider

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//struct ContentArea: View {
//    @Environment(SettingsModel.self) private var settings
//    
//    var body: some View {
//        ZStack {
//            switch settings.selectedTab {
//                case .general: GeneralPreference()
//                case .recording: RecordingPreference()
//                case .camera: CameraPreference()
//            }
//        }
//        .padding(40)
//        .background(.ultraThinMaterial)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .transition(.opacity.combined(with: .scale(scale: 0.98)))
//    }
//}
