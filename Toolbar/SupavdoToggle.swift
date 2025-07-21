//
//  SupavdoToggle.swift
//  SupaVdo
//
//  Created by Harshith on 17/06/25.
//

import SwiftUI

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
    SupavdoToggle(isActive: .constant(true))
        .frame(width: 200, height: 200)
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
            .pickerStyle(.menu)
            .fixedSize()

            Image(systemName: "chevron.down")
                .font(.caption)
                .padding(5)
                .background(.backgroundInverse.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding(.vertical, 3)
        .padding(.leading)
        .padding(.trailing, 2)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.backgroundInverse.opacity(0.1), lineWidth: 1)
        }
    }
}

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

#Preview {
    @Previewable @State var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3"]
    SupaVdoPicker(
        selection: $selectedOption,
        options: options,
        displayName: { $0 },
        onSelect: { _ in }
    )
    .frame(width: 200, height: 200)
}
