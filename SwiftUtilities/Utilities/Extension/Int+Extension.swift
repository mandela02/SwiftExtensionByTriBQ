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

public extension Int {
    var usd: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")

        // We'll force unwrap with the !, if you've got defined data you may need more error checking

        let priceString = currencyFormatter.string(from: NSNumber(value: self))
        return priceString ?? ""
    }

    var nilIfZero: Int? {
        self == 0 ? nil : self
    }

    var isOneDigit: Bool {
        return self >= 0 && self < 10
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}
