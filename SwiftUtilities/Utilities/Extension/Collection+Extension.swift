//
//  Collection+public extension.swift
//  Hamyabi
//
//  Created by TriBQ on 13/12/2021.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
