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
        case .recording: return "rectangle.dashed.badge.record"
        case .camera: return "video"
        }
    }
}

struct SettingsWindow: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ExtendedTitleBarWithTabs()
            Spacer()
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct ExtendedTitleBarWithTabs: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        HStack(spacing: 2) {
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
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)
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
                Image(systemName: tab.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .primaryOrange : .textPrimary)
                
                Text(tab.rawValue)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(isSelected ? .primaryOrange : .textPrimary)
                    .lineLimit(1)
                
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.black.opacity(0.25))
                    
                } else if isHovered {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.15))
                }
            }
        }
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
        .background(.ultraThinMaterial)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity.combined(with: .scale(scale: 0.98)))
    }
}
