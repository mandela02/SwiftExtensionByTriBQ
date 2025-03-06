//
//  NetworkImage.swift
//  Cinder
//
//  Created by TriBQ on 01/11/2022.
//

import Foundation
import SwiftUI
import NukeUI
import Nuke

public struct NetworkImage<Placeholder: View>: View {
    public init(
        url: String,
        resizingMode: ImageResizingMode = .aspectFill,
        defaultImage: SwiftUI.Image,
        defaultImagePadding: EdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10),
        loadingView: @escaping () -> Placeholder = { Color.clear }
    ) {
        self.url = url
        self.defaultImage = defaultImage
        self.loadingView = loadingView
        self.defaultImagePadding = defaultImagePadding
        self.resizingMode = resizingMode
    }
    
    let url: String
    let resizingMode: ImageResizingMode
    let defaultImage: SwiftUI.Image
    let defaultImagePadding: EdgeInsets
    let loadingView: () -> Placeholder

    var imagePipline: ImagePipeline = .shared

    public var body: some View {
        if url.isEmpty {
            defaultImageView
        } else {
            LazyImage(
                url: URL(string: url)
            ) { phase in
                if phase.isLoading {
                    loadingView()
                } else if phase.error != nil {
                    defaultImageView
                } else if let image = phase.image {
                    image
                        .resizingMode(resizingMode)
                } else {
                    defaultImageView
                }
            }
            .pipeline(imagePipline)
            .animation(.default)
            .onDisappear(.cancel)
        }
    }
    
    private var defaultImageView: some View {
        defaultImage
            .resizable()
            .scaledToFit()
            .padding(defaultImagePadding)
    }
}

extension NetworkImage {
    public func setPipline(_ imagePipline: ImagePipeline) -> NetworkImage {
        var copy = self
        copy.imagePipline = imagePipline
        return copy
    }
}
