//
//  SupavdoToggle.swift
//  SupaVdo
//
//  Created by Harshith on 17/06/25.
//

import SwiftUI
import AppKit

struct SupavdoToggle: View {
    @Binding var isActive: Bool
    var body: some View {
        Toggle("",isOn: $isActive)
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: .primaryOrange))
            .scaleEffect(0.75)
            .frame(height: 20, alignment: .center)
    }
}

#Preview {
    SomePreviewContent()
        .frame(width: 400, height: 400)
}

struct SomePreviewContent: View {
    let options = ["Optimus prime", "Opt", "Option 3"]
    @State var selectedOption = "Optimus prime"
    var body: some View {
        VStack(spacing: 10) {
            SupaVdoPicker(
                selection: $selectedOption,
                options: options,
                displayName: { $0 },
                onSelect: { _ in }
            )
            preferenceTextField(displayName: "A big Name")
        }
    }
    
    private func preferenceTextField(displayName: String) -> some View {
        HStack(spacing: 5) {
            Spacer()
            Text(displayName)
                .font(.body.weight(.regular))
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.trailing, 4)
        }
        .padding(.vertical, 3)
        .padding(.trailing, 20)
        .frame(width: 100)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.backgroundInverse.opacity(0.1), lineWidth: 1)
        }
    }
}

struct SupaVdoPicker<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let displayName: (T) -> String
    let onSelect: (T) -> Void

    init(
        selection: Binding<T>,
        options: [T],
        displayName: @escaping (T) -> String,
        onSelect: @escaping (T) -> Void
    ) {
        self._selection = selection
        self.options = options
        self.displayName = displayName
        self.onSelect = onSelect
    }

    var body: some View {
        HStack(spacing: 5) {
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                        onSelect(option)
                    }) {
                        Spacer()
                        Text(displayName(option))
                            .font(.body.monospaced().weight(.regular))
                            .foregroundStyle(.white.opacity(0.85), .white.opacity(0.85))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            } label: {
                Text(displayName(selection))
                    .font(.body.weight(.regular))
                    .foregroundStyle(.white.opacity(0.85), .white.opacity(0.85))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 50)
            }
            .labelsHidden()
            .buttonStyle(.plain)
            .pickerStyle(.menu)

            Image(systemName: "chevron.down")
                .font(.caption)
                .padding(5)
                .background(.backgroundInverse.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .frame(width: 80)
        .padding(.leading)
        .padding(.trailing, 2)
        .padding(.vertical, 3)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.backgroundInverse.opacity(0.1), lineWidth: 1)
        }
    }
}


//struct SupaVdoPicker<T: Hashable>: View {
//    @Binding var selection: T
//    let options: [T]
//    let displayName: (T) -> String
//    let onSelect: (T) -> Void
//
//    init(
//        selection: Binding<T>,
//        options: [T],
//        displayName: @escaping (T) -> String,
//        onSelect: @escaping (T) -> Void
//    ) {
//        self._selection = selection
//        self.options = options
//        self.displayName = displayName
//        self.onSelect = onSelect
//    }
//
//    var body: some View {
//        HStack(spacing: 5) {
//            Menu {
//                ForEach(options, id: \.self) { option in
//                    Button(action: {
//                        selection = option
//                        onSelect(option)
//                    }) {
//                        Text(displayName(option))
//                            .font(.body.weight(.regular))
//                            .foregroundStyle(.white.opacity(0.85))
//                    }
//                }
//            } label: {
//                Text(displayName(selection))
//                    .font(.body.weight(.regular))
//                    .foregroundStyle(.white.opacity(0.85), .white.opacity(0.85))
//                    .lineLimit(1)
//                    .truncationMode(.tail)
//            }
//            .frame(maxWidth: 200)
//            .labelsHidden()
//            .buttonStyle(.plain)
//            .pickerStyle(.menu)
//            .fixedSize()
//
//            Image(systemName: "chevron.down")
//                .font(.caption)
//                .padding(5)
//                .background(.backgroundInverse.opacity(0.05))
//                .clipShape(RoundedRectangle(cornerRadius: 5))
//        }
//        .padding(.vertical, 3)
//        .padding(.leading)
//        .padding(.trailing, 2)
//        .overlay {
//            RoundedRectangle(cornerRadius: 5)
//                .stroke(Color.backgroundInverse.opacity(0.1), lineWidth: 1)
//        }
//    }
//}

struct SupaVdoRadioPicker<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let displayName: (T) -> String
    let onSelect: (T) -> Void

    init(
        selection: Binding<T>,
        options: [T],
        displayName: @escaping (T) -> String,
        onSelect: @escaping (T) -> Void
    ) {
        self._selection = selection
        self.options = options
        self.displayName = displayName
        self.onSelect = onSelect
    }

    var body: some View {
        Picker("", selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(displayName(option))
                    .font(.footnote.weight(.regular))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .frame(maxWidth: 200)
        .labelsHidden()
        .buttonStyle(.plain)
        .pickerStyle(.radioGroup)
        .fixedSize()
    }
}

struct SupaVdoCustomRadioPicker<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let displayName: (T) -> String
    let onSelect: (T) -> Void
    
    @State private var hoveredOption: T?
    
    private let selectedColor: Color
    private let unselectedColor: Color
    private let textColor: Color
    private let layout: RadioLayout
    
    enum RadioLayout {
        case horizontal
        case vertical
    }
    
    init(
        selection: Binding<T>,
        options: [T],
        displayName: @escaping (T) -> String,
        onSelect: @escaping (T) -> Void,
        selectedColor: Color = .accentColor,
        unselectedColor: Color = .clear,
        textColor: Color = .white.opacity(0.85),
        layout: RadioLayout = .horizontal
    ) {
        self._selection = selection
        self.options = options
        self.displayName = displayName
        self.onSelect = onSelect
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.textColor = textColor
        self.layout = layout
    }
    
    var body: some View {
        Group {
            if layout == .horizontal {
                HStack(spacing: 16) {
                    radioOptions
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    radioOptions
                }
            }
        }
        .fixedSize()
    }
    
    @ViewBuilder
    private var radioOptions: some View {
        ForEach(options, id: \.self) { option in
            Button {
                selection = option
                onSelect(option)
            } label: {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                option == selection ? .primaryOrange : .backgroundInverse.opacity(0.25)
                            )
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                        
                        if option == selection {
                            Circle()
                                .fill(.white)
                                .scaledToFit()
                                .frame(width: 5, height: 5)
                                
                        }
                    }
                    
                    Text(displayName(option))
                        .font(.footnote.weight(.regular))
                        .foregroundColor(textColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .onHover { isHovered in
                hoveredOption = isHovered ? option : nil
            }
        }
    }
}

struct SupaVdoCustomMenuPicker<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let displayName: (T) -> String
    let onSelect: (T) -> Void
    
    @State private var isExpanded = false
    @State private var hoveredOption: T?
    
    private let selectedBackgroundColor: Color
    private let hoveredBackgroundColor: Color
    
    init(
        selection: Binding<T>,
        options: [T],
        displayName: @escaping (T) -> String,
        onSelect: @escaping (T) -> Void,
        selectedBackgroundColor: Color = .primaryOrange,
        hoveredBackgroundColor: Color = .clear
    ) {
        self._selection = selection
        self.options = options
        self.displayName = displayName
        self.onSelect = onSelect
        self.selectedBackgroundColor = selectedBackgroundColor
        self.hoveredBackgroundColor = hoveredBackgroundColor
    }
    
    var body: some View {
        ZStack {
            Button {
                isExpanded.toggle()
            } label: {
                HStack(spacing: 8) {
                    Text(displayName(selection))
                        .font(.body.weight(.regular))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .padding(5)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: 200)
                .background(.blue)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.backgroundInverse.opacity(0.1), lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 1) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selection = option
                            onSelect(option)
                            isExpanded = false
                        } label: {
                            HStack {
                                Text(displayName(option))
                                    .font(.body.weight(.regular))
                                    .foregroundColor(option == selection ? .white : .white.opacity(0.85))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(backgroundForOption(option))
                            }
                        }
                        .buttonStyle(.plain)
                        .onHover { isHovered in
                            hoveredOption = isHovered ? option : nil
                        }
                    }
                }
                .padding(4)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.backgroundInverse.opacity(0.15), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
        }
        .frame(maxWidth: 200)
        .background {
            if isExpanded {
                Color.clear
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        isExpanded = false
                    }
                    .ignoresSafeArea()
            }
        }
    }
    
    private func backgroundForOption(_ option: T) -> Color {
        if option == selection {
            return selectedBackgroundColor
        } else if option == hoveredOption {
            return hoveredBackgroundColor
        } else {
            return .clear
        }
    }
}


struct SupaVdoCustomMenuPickerTwo<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let displayName: (T) -> String
    let onSelect: (T) -> Void
    
    @State private var isExpanded = false
    @State private var hoveredOption: T?
    
    private let selectedBackgroundColor: Color
    private let hoveredBackgroundColor: Color
    
    init(
        selection: Binding<T>,
        options: [T],
        displayName: @escaping (T) -> String,
        onSelect: @escaping (T) -> Void,
        selectedBackgroundColor: Color = .accentColor,
        hoveredBackgroundColor: Color = .gray.opacity(0.2)
    ) {
        self._selection = selection
        self.options = options
        self.displayName = displayName
        self.onSelect = onSelect
        self.selectedBackgroundColor = selectedBackgroundColor
        self.hoveredBackgroundColor = hoveredBackgroundColor
    }
    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack(spacing: 8) {
                Text(displayName(selection))
                    .font(.body.weight(.regular))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .fixedSize()
                    .background(.orange)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .padding(5)
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .fixedSize()
//            .frame(maxWidth: 200)
            .background(isExpanded ? .accentColor : Color.clear)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.backgroundInverse.opacity(0.1), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            if isExpanded {
                VStack(spacing: 1) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selection = option
                            onSelect(option)
                            isExpanded = false
                        } label: {
                            HStack {
                                Text(displayName(option))
                                    .font(.body.weight(.regular))
                                    .foregroundColor(option == selection ? .white : .white.opacity(0.85))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .fixedSize()
                                
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(backgroundForOption(option))
                            }
                        }
                        .buttonStyle(.plain)
                        .onHover { isHovered in
                            hoveredOption = isHovered ? option : nil
                        }
                    }
                }
//                .fixedSize()
                .padding(4)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.backgroundInverse.opacity(0.15), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .offset(y: 45)
                .zIndex(1000)
            }
        }
    }
    
    private func backgroundForOption(_ option: T) -> Color {
        if option == selection {
            return selectedBackgroundColor
        } else if option == hoveredOption {
            return hoveredBackgroundColor
        } else {
            return .clear
        }
    }
}


#Preview {
    @Previewable @State var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3"]
    SupaVdoPicker(
        selection: $selectedOption,
        options: options,
        displayName: { $0 },
        onSelect: { _ in }
    )
    .frame(width: 400, height: 400)
}
