//
//  View+Extension.swift
//  Cinder
//
//  Created by TriBQ on 04/09/2022.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func badgeNumber(_ value: Int?, font: Font,
                     backgroundColor: Color,
                     foregroundColor: Color) -> some View {
        self
            .overlay(Badge(count: value, font: font,
                           backgroundColor: backgroundColor,
                           foregroundColor: foregroundColor))
    }
    
    @ViewBuilder
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    @ViewBuilder
    func blinking(duration: Double = 0.75) -> some View {
        modifier(BlinkAnimationModifier(duration: duration))
    }
    
    @ViewBuilder
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    @ViewBuilder
    func backgroundColor(_ color: Color) -> some View {
        self.background(color)
    }

    @ViewBuilder
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    @ViewBuilder
    func clearListCell() -> some View {
        self
            .listRowSeparatorTint(.clear)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    @ViewBuilder
    func navigationBar<Content: View>(child: Content) -> some View {
        VStack(spacing: 0) {
            child
                .frame(maxWidth: .infinity)

            self
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @ViewBuilder
    var plainButton: some View {
        self.buttonStyle(PlainButtonStyle())
    }

    var uiView: UIView {
        let view = UIHostingController(rootView: self).view
        return view ?? UIView()
    }

    @ViewBuilder
    func strikeThrought(color: Color) -> some View {
        ZStack {
            self

            color
                .frame(height: 2)
        }
        .fixedSize(horizontal: true, vertical: true)
    }

    @ViewBuilder
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        self.background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: ViewSizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(ViewSizePreferenceKey.self, perform: onChange)
    }

    @ViewBuilder
    func blurBackground() -> some View {
        self.background(
            Color.black
                .ignoresSafeArea()
                .opacity(0.8)
                .background(
                    .ultraThinMaterial
                )
        )
    }

    func setBackgroundList() -> some View {
        self.modifier(ListBackgroundModifier())
    }
}

public extension View {
    func onEnterBackground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification),
            perform: { _ in f() }
        )
    }
    
    func onEnterForeground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification),
            perform: { _ in f() }
        )
    }
    
    func onBecomeActive(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
            perform: { _ in f() }
        )
    }
}

private struct ViewSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct RoundedCorner: Shape {
    init(radius: CGFloat = .infinity,
                corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    private var radius: CGFloat
    private var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
