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
