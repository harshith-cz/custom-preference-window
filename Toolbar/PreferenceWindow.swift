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
            ExtendedTitleBarWithTabs()
            
            ContentArea()
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct ExtendedTitleBarWithTabs: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        VStack(spacing: 0) {
            // Title area
            HStack {
                Spacer()
                
                Text("Settings")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            // Tabs area
            HStack(spacing: 32) {
                ForEach(SettingsTab.allCases) { tab in
                    TitleBarTab(
                        tab: tab,
                        isSelected: settings.selectedTab == tab
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            settings.selectedTab = tab
                        }
                    }
                }
            }
            .padding(.bottom, 16)
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

struct TitleBarTab: View {
    let tab: SettingsTab
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.accentColor)
                            .frame(width: 40, height: 40)
                    } else if isHovered {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : .primary)
                        .frame(width: 40, height: 40)
                }
                
                Text(tab.rawValue)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .help("\(tab.rawValue) Settings")
    }
}

struct ContentArea: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        ZStack {
            Color(NSColor.textBackgroundColor)
            
            VStack(spacing: 20) {
                Text("Content for \(settings.selectedTab.rawValue)")
                    .font(.title2)
                    .foregroundColor(.primary)
                
                Text("This is where the \(settings.selectedTab.rawValue.lowercased()) settings content will go.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity.combined(with: .scale(scale: 0.98)))
    }
}
