//
//  UISegmentedControl+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/8/2022.
//

import UIKit

public extension UISegmentedControl {
    func selectedSegmentTitleColor(_ color: UIColor) {
        var attributes = self.titleTextAttributes(for: .selected) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: .selected)
    }
    func unselectedSegmentTitleColor(_ color: UIColor) {
        var attributes = self.titleTextAttributes(for: .normal) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: .normal)
    }
}
