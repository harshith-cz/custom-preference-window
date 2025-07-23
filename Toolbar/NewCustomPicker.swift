//
//  NewCustomPicker.swift
//  Toolbar
//
//  Created by Harshith on 22/07/25.
//

import SwiftUI
import AppKit

struct SupaVdoCustRadioPicker<T: Hashable>: View {
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
                        .font(.body.weight(.regular))
                        .foregroundColor(.white.opacity(0.85))
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

struct SupaVdoCustMenuPicker<T: Hashable>: View {
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
                .compositingGroup()
                .background(Color(NSColor.controlBackgroundColor))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.backgroundInverse.opacity(0.15), lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                .offset(y: 60)
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
