//
//  File.swift
//  
//
//  Created by TriBQ on 01/05/2023.
//

import Foundation
import SwiftUI
import Lottie

public struct LottieView: UIViewRepresentable {
    public init(file: String,
                bundle: Bundle = .main) {
        self.file = file
        self.bundle = bundle
    }

    let file: String
    let bundle: Bundle

    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView()
        if let animation = LottieAnimation.named(file, bundle: bundle) {
            animationView.animation = animation
        }

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: animationView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: animationView.trailingAnchor),
            view.topAnchor.constraint(equalTo: animationView.topAnchor),
            view.bottomAnchor.constraint(equalTo: animationView.bottomAnchor)
        ])

        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {

    }

    public typealias UIViewType = UIView
}
