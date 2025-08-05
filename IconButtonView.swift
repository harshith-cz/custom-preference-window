//
//  IconButtonView.swift
//  Toolbar
//
//  Created by Harshith on 30/07/25.
//

import SwiftUI

struct IconButtonView<MenuContent: View>: View {
    let image: Image
    let action: () -> Void
    let hasDropdown: Bool
    @ViewBuilder let menuContent: () -> MenuContent
    @State private var didHover: Bool = false
    
    init(
        image: Image,
        action: @escaping () -> Void,
        @ViewBuilder menuContent: @escaping () -> MenuContent = { EmptyView() }
    ) {
        self.image = image
        self.action = action
        self.hasDropdown = !(MenuContent.self == EmptyView.self)
        self.menuContent = menuContent
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.iconDefault)
                    .padding(8)
                    .animation(.easeInOut(duration: 0.2), value: image)
                
                if hasDropdown {
                    Menu {
                        menuContent()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.body)
                            .fontWeight(.regular)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                    }
                    .menuStyle(.borderlessButton)
                    .menuIndicator(.hidden)
                    .fixedSize()
                }
            }
            .padding(2)
            .contentShape(Rectangle())
            
        }
        .frame(height: 48)
        .scaledToFit()
        .onTapGesture {
            action()
        }
        .onHover { hover in
            didHover = hover
        }
        .background(didHover ? Color.primary.opacity(0.1) : Color.clear, in: RoundedRectangle(cornerRadius: 8))
        .animation(.easeInOut(duration: 0.15), value: didHover)
    }
}

#Preview {
    HStack(spacing: 20) {
        // Example without dropdown
        IconButtonView(
            image: Image(systemName: "gearshape"),
            action: {
                print("Gear tapped")
            }
        ) {
            Button("Option 1", action: { print("Option 1 selected") })
            Button("Option 2", action: { print("Option 2 selected") })
            Divider()
            Button("Quit", action: { print("Quit selected") })
        }
        
        // Example with dropdown menu
        IconButtonView(
            image: Image(systemName: "gearshape"),
            action: {
                print("Gear tapped")
            }
        ) {
            Button("Option 1", action: { print("Option 1 selected") })
            Button("Option 2", action: { print("Option 2 selected") })
            Divider()
            Button("Quit", action: { print("Quit selected") })
        }
        IconButtonView(
            image: Image(systemName: "gearshape"),
            action: {
                print("Gear tapped")
            }
        ) {
            Button("Option 1", action: { print("Option 1 selected") })
            Button("Option 2", action: { print("Option 2 selected") })
            Divider()
            Button("Quit", action: { print("Quit selected") })
        }
    }
    .padding(.vertical, 2)
    .padding(.horizontal, 2)
    .frame(height: 50)
    .background(Color.secondary.opacity(0.25), in: RoundedRectangle(cornerRadius: 10))
    .frame(width: 400, height: 400)
}
