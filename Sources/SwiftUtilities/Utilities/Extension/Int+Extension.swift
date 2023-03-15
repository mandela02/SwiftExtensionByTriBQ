//
//  Int+public extension.swift
//  Hamyabi
//
//  Created by TriBQ on 11/12/2021.
//

import Foundation

public extension Int {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    /// Convert an integer to a string
    var asString: String { "\(self)" }

    /// Convert an integer to data
    var asData: Data? { asString.asData }

    /// Convert an integer to a double
    var asDouble: Double? { Double(self) }

    /// Convert an integer to a bool
    var asBool: Bool { self == 1 }
}
