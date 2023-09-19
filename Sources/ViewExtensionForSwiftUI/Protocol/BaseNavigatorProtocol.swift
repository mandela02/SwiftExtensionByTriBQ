//
//  BaseNavigatorProtocol.swift
//  CannabisViews
//
//  Created by TriBQ on 10/04/2023.
//

import Foundation
import UIKit

public protocol BaseNavigatorProtocol {
    var navigationController: UINavigationController { get }

    func dismiss()
    func pop()
    func popToRoot()
}

public extension BaseNavigatorProtocol {
    func dismiss() {
        navigationController.dismiss(animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
