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
        ContentArea()
            .frame(width: 600)
            .fixedSize(horizontal: true, vertical: true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ExtendedTitleBarWithTabs()
                }
            }
            .background(.ultraThinMaterial)
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
    }
}

struct TitleBarTab: View {
    let tab: SettingsTab
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : .primary)
                
                Text(tab.rawValue)
                    .font(.caption.weight(.medium))
                    .foregroundColor(isSelected ? .accentColor : .primary)
                    .lineLimit(1)
            }
            .frame(minWidth: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.selection)
            } else if isHovered {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.primary.opacity(0.1))
            }
        }
    }
}

struct ContentArea: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        Group {
            switch settings.selectedTab {
                case .general: GeneralPreference()
                case .recording: RecordingPreference()
                case .camera: CameraPreference()
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.25), value: settings.selectedTab)
    }
}

struct GeneralPreference: View {
    @State var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PreferenceRow(
                title: NSLocalizedString("Theme", comment: "")
            ) {
                SupaVdoPicker(
                    selection: $selectedOption,
                    options: options,
                    displayName: { $0 },
                    onSelect: { _ in }
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CameraPreference: View {
    @State var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3"]
    let options2 = ["30 fps", "60 fps"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PreferenceRow(
                title: NSLocalizedString("Camera", comment: "")
            ) {
                SupaVdoPicker(
                    selection: $selectedOption,
                    options: options,
                    displayName: { $0 },
                    onSelect: { _ in }
                )
            }
            Divider()

            PreferenceRow(
                title: NSLocalizedString("Resolution", comment: "")
            ) {
                SupaVdoPicker(
                    selection: $selectedOption,
                    options: options,
                    displayName: { $0 },
                    onSelect: { _ in }
                )
            }
            Divider()

            PreferenceRow(
                title: NSLocalizedString("Frame Rate", comment: "")
            ) {
                SupaVdoRadioPicker(
                    selection: $selectedOption,
                    options: options2,
                    displayName: { $0 },
                    onSelect: { _ in }
                )
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RecordingPreference: View {
    @State private var isRecordMicrophoneEnabled = true
    @State var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PreferenceRow(
                title: NSLocalizedString("Record Microphone", comment: "")
            ) {
                SupavdoToggle(isActive: $isRecordMicrophoneEnabled)
            }
            Divider()

            PreferenceRow(
                title: NSLocalizedString("Record System Audio", comment: "")
            ) {
                SupavdoToggle(isActive: $isRecordMicrophoneEnabled)
            }
            Divider()

            PreferenceRow(
                title: NSLocalizedString("Record System Audio", comment: "")
            ) {
                SupaVdoPicker(
                    selection: $selectedOption,
                    options: options,
                    displayName: { $0 },
                    onSelect: { _ in }
                )
            }
            Divider()

            PreferenceRow(
                title: NSLocalizedString("Start / Stop Recording", comment: "")
            ) {
                SupaVdoPicker(
                    selection: $selectedOption,
                    options: options,
                    displayName: { $0 },
                    onSelect: { _ in }
                )
            }
            Divider()

            PreferenceRow(
                title: NSLocalizedString("Pause / Resume Recording", comment: "")
            ) {
                SupaVdoPicker(
                    selection: $selectedOption,
                    options: options,
                    displayName: { $0 },
                    onSelect: { _ in }
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PreferenceRow<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.footnote.weight(.regular))
                .foregroundColor(.secondary)
            Spacer()
            content
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SettingsWindow()
        .environment(SettingsModel())
}
