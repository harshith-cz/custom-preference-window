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
            CustomTitleBarWithTabs()
            
            SettingsContentView()
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct CustomTitleBarWithTabs: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        VStack(spacing: 0) {
            TabsSection()
        }
        .background(Color.clear)
        .overlay(
            Rectangle()
                .fill(Color(NSColor.separatorColor))
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
}

struct TabsSection: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(SettingsTab.allCases) { tab in
                TabItem(
                    tab: tab,
                    isSelected: settings.selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        settings.selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
    }
}

struct TabItem: View {
    let tab: SettingsTab
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundGradient)
                        .frame(width: 42, height: 42)
                        .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(tab.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textColor)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .help("\(tab.rawValue) Settings")
    }
    
    private var backgroundGradient: LinearGradient {
        if isSelected {
            return LinearGradient(
                colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else if isHovered {
            return LinearGradient(
                colors: [Color.gray.opacity(0.15), Color.gray.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            return LinearGradient(
                colors: [Color.gray.opacity(0.08), Color.gray.opacity(0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var iconColor: Color {
        isSelected ? .white : .primary
    }
    
    private var textColor: Color {
        isSelected ? .accentColor : .primary
    }
    
    private var shadowColor: Color {
        isSelected ? Color.accentColor.opacity(0.3) : Color.black.opacity(0.1)
    }
    
    private var shadowRadius: CGFloat {
        isSelected ? 3 : 1
    }
    
    private var shadowOffset: CGFloat {
        isSelected ? 1 : 0.5
    }
}

struct SettingsContentView: View {
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
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

struct GeneralSettingsView: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderSection(
                    title: "General Settings",
                    description: "Configure general application preferences and behaviors."
                )
                
                SettingsGroup(title: "Appearance") {
                    SettingsRow(label: "Theme") {
                        Picker("Theme", selection: .constant("System")) {
                            Text("Light").tag("Light")
                            Text("Dark").tag("Dark")
                            Text("System").tag("System")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                    
                    SettingsRow(label: "Window Style") {
                        Picker("Window Style", selection: .constant("Modern")) {
                            Text("Classic").tag("Classic")
                            Text("Modern").tag("Modern")
                        }
                        .pickerStyle(.menu)
                        .frame(width: 120)
                    }
                }
                
                SettingsGroup(title: "Behavior") {
                    SettingsRow(label: "Launch at Login") {
                        Toggle("", isOn: .constant(false))
                    }
                    
                    SettingsRow(label: "Show in Menu Bar") {
                        Toggle("", isOn: .constant(true))
                    }
                }
                
                Spacer()
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct RecordingSettingsView: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderSection(
                    title: "Recording Settings",
                    description: "Adjust video and audio recording parameters."
                )
                
                SettingsGroup(title: "Video Quality") {
                    SettingsRow(label: "Resolution") {
                        Picker("Resolution", selection: .constant("1080p")) {
                            Text("720p").tag("720p")
                            Text("1080p").tag("1080p")
                            Text("4K").tag("4K")
                        }
                        .pickerStyle(.menu)
                        .frame(width: 100)
                    }
                    
                    SettingsRow(label: "Frame Rate") {
                        Picker("Frame Rate", selection: .constant("30")) {
                            Text("24 fps").tag("24")
                            Text("30 fps").tag("30")
                            Text("60 fps").tag("60")
                        }
                        .pickerStyle(.menu)
                        .frame(width: 100)
                    }
                }
                
                SettingsGroup(title: "Audio") {
                    SettingsRow(label: "Record Audio") {
                        Toggle("", isOn: .constant(true))
                    }
                    
                    SettingsRow(label: "Audio Quality") {
                        Picker("Audio Quality", selection: .constant("High")) {
                            Text("Low").tag("Low")
                            Text("Medium").tag("Medium")
                            Text("High").tag("High")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                }
                
                Spacer()
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct CameraSettingsView: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderSection(
                    title: "Camera Settings",
                    description: "Configure camera overlay and positioning options."
                )
                
                SettingsGroup(title: "Camera Position") {
                    SettingsRow(label: "Position") {
                        Picker("Position", selection: .constant("Top Right")) {
                            Text("Top Left").tag("Top Left")
                            Text("Top Right").tag("Top Right")
                            Text("Bottom Left").tag("Bottom Left")
                            Text("Bottom Right").tag("Bottom Right")
                        }
                        .pickerStyle(.menu)
                        .frame(width: 140)
                    }
                    
                    SettingsRow(label: "Size") {
                        Slider(value: .constant(0.5), in: 0.1...1.0) {
                            Text("Size")
                        }
                        .frame(width: 200)
                    }
                }
                
                SettingsGroup(title: "Overlay Style") {
                    SettingsRow(label: "Shape") {
                        Picker("Shape", selection: .constant("Circle")) {
                            Text("Circle").tag("Circle")
                            Text("Rectangle").tag("Rectangle")
                            Text("Rounded Rectangle").tag("Rounded Rectangle")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 280)
                    }
                    
                    SettingsRow(label: "Border") {
                        Toggle("", isOn: .constant(true))
                    }
                }
                
                Spacer()
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct HeaderSection: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
    }
}

struct SettingsGroup<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                content
            }
        }
    }
}

struct SettingsRow<Content: View>: View {
    let label: String
    let content: Content
    
    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
}
