//
//  BlinkAnimationModifier.swift
//  Cinder
//
//  Created by TriBQ on 04/09/2022.
//

import SwiftUI

public struct BlinkAnimationModifier: ViewModifier {
    
    let duration: Double
    @State private var blinking: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: duration).repeatForever()) {
                    blinking = true
                }
            }
    }
}
