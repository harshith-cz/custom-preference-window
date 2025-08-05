//
//  SupavdoAccordion.swift
//  Toolbar
//
//  Created by Harshith on 28/07/25.
//

import SwiftUI

struct SupavdoAccordion<Content: View> : View {
    @Binding var isSelected: Bool
    @State private var isActive: Bool
    let title: String
    let content: () -> Content
    init(title: String, isActive: Bool = false, isSelected: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping () -> Content) {
            self.title = title
            self._isActive = State(initialValue: isActive)
            self._isSelected = isSelected
            self.content = content
        }
    let cornerRadius: CGFloat = 6
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            if isActive {
                expandedContent
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.surfaceBackground.opacity(isActive ? 0.1 : 0.06), in: RoundedRectangle(cornerRadius: cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.strokePrimary, lineWidth: 1)
                .opacity(isActive ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
    
    private var header: some View {
        HStack {
            headerTitle(title: title)
            Spacer()
            chevron
        }
        .frame(minHeight: 35)
        .padding(.horizontal, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut) {
                isActive.toggle()
            }
        }
    }
    
    private var expandedContent: some View {
        content()
            .transition(.opacity)
    }
    
    private func headerTitle(title: String) -> some View{
        Text(title)
            .font(.callout)
            .fontWeight(.light)
            .foregroundStyle(.textHeadline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var chevron: some View {
        Image(systemName: "chevron.down")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .fontWeight(.regular)
            .frame(width: 14, height: 12)
            .rotationEffect(.degrees(isActive ? 180 : 0))
            .animation(.easeInOut, value: isActive)
            .foregroundColor(isActive ? .iconActive : .iconInactive)
    }
}

#Preview {
    SupavdoAccordion(
        title: "Wallpaper", isSelected: .constant(false), content: {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
        }
    )
    .padding(.horizontal, 10)
    .frame(width: 200, height: 200)
}
