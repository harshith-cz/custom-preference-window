//
//  FloatingToolbar.swift
//  Toolbar
//
//  Created by Harshith on 24/07/25.
//

import SwiftUI

struct ToolbarWithWallpaperView: View {
    @State private var toolbar = FloatingToolbar()

    var body: some View {
        ZStack {
            Image("wallpaper_one")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
            HStack {
//                FloatingToolbarNewView()
                Color.clear.frame(width: 100)
                FloatingToolbarView(manager: toolbar)
            }
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .frame(width: 500, height: 500)
    }
}
struct FloatingToolbarNewView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.on.rectangle")
                .foregroundColor(.white)

            VStack {
                Button(action: {}) {
                    Image(systemName: "pause.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                }
                .buttonStyle(.plain)

                Text("01:00")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)

                Button(action: {}) {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.red))
                }
                .buttonStyle(.plain)
            }
            .clipShape(Capsule())
            .padding(.horizontal, 9)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .red.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    BlurView()
                        .clipShape(Capsule())
                        .opacity(0.9)
                }
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.black, .black.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            )

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(
            BlurView()
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .opacity(0.25)
        )
    }
}


struct FloatingToolbarView: View {
    private let floatingToolbar: FloatingToolbar
    @State private var isHidden = false
    
    init(manager: FloatingToolbar) {
        self.floatingToolbar = manager
    }
    
    var body: some View {
        ZStack {
            if !isHidden {
                mainToolbar
                    .transition(.move(edge: .trailing))
            }
            
            if isHidden {
                showArrow
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isHidden)
    }

    var mainToolbar: some View {
        VStack {
            toolbarIcon
            innerCapsule
            rightButton
        }
        .padding(.horizontal, 2)
        .padding(.vertical, 10)
        .background(
            BlurView()
                .clipShape(Capsule())
                .opacity(0.25)
        )
        .padding(1)
        .overlay(
            Capsule()
                .stroke(
                    Color.white.opacity(0.5),
                    lineWidth: 1.5
                )
                .opacity(0.25)
        )
        .padding(2)
    }
    
    private var showArrow: some View {
        Button {
            isHidden = false
        } label: {
            Image(systemName: "chevron.left")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 14, height: 14)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            BlurView()
                .opacity(0.25)
                .clipShape(
                    PartialRoundedCornersShape(
                        corners: [.topLeading, .bottomLeading],
                        radius: 12
                    )
                )
            )
    }
    
    private var toolbarIcon: some View {
        Image("menu_bar_icon")
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
            .foregroundColor(.white)
    }
    
    private var innerCapsule: some View {
        VStack(spacing: 8) {
            playPauseButton
            timerDisplay
            stopButton
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 12)
        .background {
            BlurView()
                .opacity(0.5)
                .overlay {
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.black.opacity(0.7), .black]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .opacity(0.4)
                }
                .clipShape(Capsule())
        }
        .overlay(
            Capsule()
                .stroke(
                    .black.opacity(0.1),
                    lineWidth: 1
                )
        )
    }
    
    private var rightButton: some View {
        Button {
            isHidden = true
        } label: {
            Image(systemName: "chevron.right")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 14, height: 14)
        }
        .buttonStyle(.plain)
    }

    private var playPauseButton: some View {
        SupaCircleButton(
            backgroundColor: .iconInactive,
            isEnabled: floatingToolbar.isPlayPauseEnabled,
            action: floatingToolbar.handlePlayPauseAction,
        ) {
              Image(systemName: floatingToolbar.playPauseIconName)
                .font(.system(size: 9))
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
    }
    

    private var timerDisplay: some View {
        Text(floatingToolbar.formattedElapsedTime)
            .font(.caption.monospacedDigit().weight(.semibold))
            .foregroundColor(.textVibrantDark)
            .frame(width: 32)
            .animation(.none, value: floatingToolbar.formattedElapsedTime)
    }

    private var stopButton: some View {
        SupaCircleButton(
            backgroundColor: .red,
            action: floatingToolbar.handleStopAction
        ) {
              Image(systemName: "stop.fill")
                .font(.system(size: 9))
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }
}

struct SupaCircleButton<Content: View>: View {
    let action: () -> Void
    let size: CGFloat
    let isEnabled: Bool
    let iconColor: Color
    let backgroundColor: Color
    let content: () -> Content

    init(
        iconColor: Color = .black,
        backgroundColor: Color = .iconInactive,
        size: CGFloat = 20,
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
        self.iconColor = iconColor
        self.backgroundColor = backgroundColor
        self.content = content
    }

    var body: some View {
        Button(action: action) {
            content()
                .frame(width: size, height: size)
                .background(backgroundColor)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

struct BlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow
        view.blendingMode = .withinWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

@MainActor
@Observable
final class FloatingToolbar {
    private var panel: NSPanel?
    private var timer: Timer?
    private(set) var isPaused: Bool = false
    private(set) var isRecording: Bool = false
    private(set) var elapsedTime: TimeInterval = 0

    func show(on display: NSScreen? = NSScreen.main) {
        let view = FloatingToolbarView(manager: self)
        let panel = createPanel(with: view)
        self.panel = panel
        if let screen = display {
            positionAtBottomRight(on: screen)
        }
        panel.makeKeyAndOrderFront(nil)
    }

    func handlePlayPauseAction() {
        if isPaused {
            resume()
        } else {
            pause()
        }
    }

    func handleStopAction() {
        stop()
    }

    var playPauseIconName: String {
        isPaused ? "play.fill" : "pause.fill"
    }

    var isPlayPauseEnabled: Bool { true } // You can later customize logic
    var isStopEnabled: Bool { true }

    var formattedElapsedTime: String {
        formattedTime(elapsedTime)
    }

    // MARK: Timer logic
    func start() {
        isRecording = true
        isPaused = false
        startTimer()
    }

    private func pause() {
        isPaused = true
        stopTimer()
    }

    private func resume() {
        isPaused = false
        startTimer()
    }

    private func stop() {
        isRecording = false
        isPaused = false
        stopTimer()
        elapsedTime = 0
    }

    private func startTimer() {
        guard timer == nil else { return }
        let newTimer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.elapsedTime += 1 }
        }
        RunLoop.main.add(newTimer, forMode: .common)
        timer = newTimer
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: Panel
    private func createPanel(with rootView: some View) -> NSPanel {
        let hostingView = NSHostingView(rootView: rootView)

        let panel = NSPanel(
            contentRect: NSRect(origin: .zero, size: NSSize(width: 80, height: 180)),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.contentView = hostingView
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.backgroundColor = .clear
        panel.isOpaque = false
        return panel
    }

    private func positionAtBottomRight(on screen: NSScreen) {
        guard let panel = panel else { return }
        let screenFrame = screen.visibleFrame
        let newOrigin = CGPoint(
            x: screenFrame.maxX - panel.frame.width - 20,
            y: screenFrame.minY + 120
        )
        panel.setFrameOrigin(newOrigin)
    }
}

func formattedTime(_ elapsedTime: Double) -> String {
    let totalSeconds = Int(elapsedTime)
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let seconds = totalSeconds % 60
    return hours > 0
        ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        : String(format: "%02d:%02d", minutes, seconds)
}

#Preview {
    ToolbarWithWallpaperView()
        .frame(width: 400, height: 400)
}

struct PartialRoundedCornersShape: Shape {
    let corners: [Corner]
    let radius: CGFloat
    
    enum Corner {
        case topLeading, topTrailing, bottomLeading, bottomTrailing
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topLeft = corners.contains(.topLeading) ? radius : 0
        let topRight = corners.contains(.topTrailing) ? radius : 0
        let bottomRight = corners.contains(.bottomTrailing) ? radius : 0
        let bottomLeft = corners.contains(.bottomLeading) ? radius : 0
        
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        
        if topRight > 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
                radius: topRight,
                startAngle: Angle(degrees: -90),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
        }
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        
        if bottomRight > 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
                radius: bottomRight,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
        }
        
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        
        if bottomLeft > 0 {
            path.addArc(
                center: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft),
                radius: bottomLeft,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
        }
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        
        if topLeft > 0 {
            path.addArc(
                center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
                radius: topLeft,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
        }
        
        path.closeSubpath()
        return path
    }
}
