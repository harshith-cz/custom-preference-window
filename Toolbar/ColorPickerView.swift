//
//  ColorPickerView.swift
//  Toolbar
//
//  Created by Harshith on 31/07/25.
//

import SwiftUI

struct ColorPickerView: View {
    let color: Color
    let hexString: String
    let onColorChange: (Color) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
                    .frame(width: 30, height: 30)
                
                ColorPicker(
                    "",
                    selection: Binding(
                        get: { color },
                        set: { onColorChange($0) }
                    ),
                    supportsOpacity: true
                )
                .scaleEffect(x:0.75, y: 1.3)
                .labelsHidden()
                .opacity(0.1)
            }
            .frame(width: 30, height: 30)
            .padding(2)
            Text(hexString)
                .font(.caption.monospaced())
                .fontWeight(.regular)
                .foregroundStyle(.textHeadline)
                .padding(.trailing, 2)
                .padding(.horizontal, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        .fixedSize()
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ColorPickerView(
        color: .white, hexString: "white", onColorChange:   {
            print("hello \($0)")
        }
    )
    .frame(width: 200, height: 200)
}
