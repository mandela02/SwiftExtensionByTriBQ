//
//  Array+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation

public extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

public extension Array where Element == String {
    var toString: String? {
        self.isEmpty ? nil : self.joined(separator: ", ")
    }
}

public extension Array where Element == Double {
    func sum() -> Double {
        self.reduce(0, +)
    }
}

public extension Array {
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    mutating func safeInsert(contentsOf elements: [Element], at index: Int) throws {
        if self.count >= index {
            self.insert(contentsOf: elements, at: index)
        } else {
            throw NSError(domain: "Out of range when trying to insert at \(index)", code: 999)
        }
    }
    
    mutating func safeInsert(_ element: Element, at index: Int) throws {
        if self.count >= index {
            self.insert(element, at: index)
        } else {
            throw NSError(domain: "Out of range when trying to insert at \(index)", code: 999)
        }
    }
}
