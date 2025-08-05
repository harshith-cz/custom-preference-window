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
        case .general: return "gear"
        case .recording: return "rectangle.dashed.badge.record"
        case .camera: return "video"
        }
    }
}

struct SettingsWindow: View {
    @Environment(SettingsModel.self) private var settings
    
    var body: some View {
        VStack(spacing: 0) {
            ContentArea()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: 0) {
                            Spacer()
                            ExtendedTitleBarWithTabs()
                            Spacer()
                        }
                    }
                }
                .background(.ultraThinMaterial)
        }
        .frame(width: 500)
        .fixedSize(horizontal: true, vertical: true)
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
                    .foregroundColor(isSelected ? .primaryOrange : .backgroundInverse.opacity(0.48))
                
                Text(tab.rawValue)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(isSelected ? .primaryOrange : .backgroundInverse.opacity(0.48))
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
        Group {
            switch settings.selectedTab {
                case .general: GeneralPreference()
                case .recording: RecordingPreference()
                case .camera: CameraPreference()
            }
        }
        .padding(.horizontal, 70)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.3), value: settings.selectedTab)
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
                .foregroundColor(.backgroundInverse.opacity(0.75))
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
