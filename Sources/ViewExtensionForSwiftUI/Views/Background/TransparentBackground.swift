//
//  File.swift
//  
//
//  Created by TriBQ on 31/05/2023.
//

import Foundation
import SwiftUI

public struct FullScreenBottomSheet<T: View>: View {
    public init(child: T) {
        self.child = child
    }

    let child: T

    public var body: some View {
        VStack {
            Spacer()

            child
        }
        .background(TransparentBackground())
    }
}

public struct TransparentBackground: UIViewRepresentable {
    public init() {}

    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}
