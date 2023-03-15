//
//  BaseViewModel.swift
//  Cinder
//
//  Created by TriBQ on 28/08/2022.
//

import Foundation
import Combine

open class BaseViewModel<Output>: ObservableObject {
    public init(state: Output) {
        self.state = state

        Publishers
            .Merge(NotificationCenter.default.publisher(for: .themeDidChange),
                   NotificationCenter.default.publisher(for: .languageDidChange))
            .map { _ in }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.objectWillChange.send()
            })
            .store(in: &cancellables)
    }
    
    public var cancellables = Set<AnyCancellable>()

    @Published
    public var state: Output
}

public extension Notification.Name {
    static let themeDidChange = Notification.Name("THEME_DID_CHANGE")
    static let languageDidChange = Notification.Name("LANGUAGE_DID_CHANGE")
}
