//
//  File.swift
//  
//
//  Created by TriBQ on 31/05/2023.
//

import Foundation
import SwiftUI

public struct RefreshableScrollView<Content: View>: View {
    @ViewBuilder
    var content: () -> Content
    var onRefresh: () async -> Void

    public init(
        @ViewBuilder content: @escaping () -> Content,
        onRefresh: @escaping () async -> Void
    ) {
        self.content = content
        self.onRefresh = onRefresh
    }

    public var body: some View {
        List {
            Section {
                content()
                    .clearListCell()
            }
        }
        .setBackgroundList()
        .listStyle(.plain)
        .refreshable {
            await onRefresh()
        }
    }
}
