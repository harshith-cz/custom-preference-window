//
//  Buttons.swift
//  Toolbar
//
//  Created by Harshith on 23/07/25.
//

import SwiftUI

struct Buttons: View {
    @State private var isPlaying: Bool = false
    var body: some View {
        VStack {
            cancelButton(onCancel: {})
            CircleButton(
                icon: "pause.fill",
                iconSize: 16,
                size: 34,
                action: {
                    print("Hello world")
                }
            )
            
            PlayPauseButton(isPlaying: isPlaying) {
                isPlaying.toggle()
                print("Hello")
            }
        }
    }
    
    private func cancelButton(onCancel: @escaping () -> Void) -> some View {
        Button(action: onCancel) {
            Text("Cancel")
                .font(.body.weight(.regular))
                .foregroundColor(Color.backgroundInverse.opacity(0.85))
                .padding(.vertical, 5)
                .padding(.horizontal, 35)
        }
        .background(Color.backgroundBase.opacity(0.1), in: RoundedRectangle(cornerRadius: 5))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.backgroundInverse.opacity(0.25), lineWidth: 0.5)
                .blur(radius: 0.5)
                .offset(x: 0, y: 0.5)
                .mask(
                    RoundedRectangle(cornerRadius: 6)
                )
        )
    }
}

//struct PlayPauseButton: View {
//    let isPlaying: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button {
//            action() // Trigger the action from the parent
//        } label: {
//            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 10, height: 10)
//                .foregroundColor(.black)
//                .accessibilityElement(children: .ignore)
//                .accessibilityLabel(Text(isPlaying ? "Pause" : "Play"))
//        }
//        .contentShape(Circle())
//        .padding(5)
//        .frame(width: 25, height: 25)
//        .background(Color.iconInactive)
//        .buttonStyle(PlainButtonStyle())
//        .clipShape(Circle())
//    }
//}

struct PlayPauseButton: View {
    let isPlaying: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.black)
                .accessibilityLabel(Text(isPlaying ? "Pause" : "Play"))
                .frame(width: 25, height: 25)
                .background(Color.iconInactive)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(isPlaying ? "Pause" : "Play"))
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Circle())
    }
}

struct CircleButton: View {
    let icon: String
    let iconSize: CGFloat
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Image(systemName: icon)
                    .foregroundColor(.backgroundPrimary)
                    .font(.system(size: iconSize))
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .background(.iconBackground)
            .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    Buttons()
        .frame(width: 400, height: 300)
}
