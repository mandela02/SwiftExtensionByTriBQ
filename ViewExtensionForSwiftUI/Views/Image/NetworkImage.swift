//
//  NetworkImage.swift
//  Cinder
//
//  Created by TriBQ on 01/11/2022.
//

import Foundation
import SwiftUI
import NukeUI

public struct NetworkImage<Placeholder: View>: View {
    public init(
        url: String,
        defaultImage: SwiftUI.Image,
        loadingView: @escaping () -> Placeholder = { Color.clear }
    ) {
        self.url = url
        self.defaultImage = defaultImage
        self.loadingView = loadingView
    }
    
    let url: String
    let defaultImage: SwiftUI.Image
    let loadingView: () -> Placeholder
    
    public var body: some View {
        if url.isEmpty {
            defaultImageView
        } else {
            LazyImage(url: URL(string: url)) { phase in
                if phase.isLoading {
                    loadingView()
                } else if phase.error != nil {
                    defaultImageView
                } else if let image = phase.image {
                    image
                } else {
                    defaultImageView
                }
            }
            .animation(.default)
            .onDisappear(.cancel)
        }
    }
    
    private var defaultImageView: some View {
        defaultImage
            .resizable()
            .scaledToFit()
            .padding(.all, 10)
    }
}
