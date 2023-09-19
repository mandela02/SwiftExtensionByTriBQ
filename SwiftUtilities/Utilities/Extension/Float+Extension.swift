//
//  Float+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation

public extension Float {
    /// Round a number to the specified number of decimal places
    func round(to decimalPlaces: Int) -> Float {
        let multiplier = pow(10.0, Float(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }

    /// Format the number as a percentage with no decimal places
    var asPct: String { "\(Int(self * 100))%" }

    /// Format the number with commas and exactly two decimal places
    var commasTwoDecimals: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    /// Format the number with commas and no decimal places
    var commas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    /// Format the number as an abbreviation with at most one decimal place
    var abbreviatedFormat: String {
        if self >= 1000, self < 1_000_000 {
            return ("\((self / 1000).round(to: 1))k").replacingOccurrences(of: ".0", with: "")
        } else if self > 1_000_000 {
            return ("\((self / 1_000_000).round(to: 1))M").replacingOccurrences(of: ".0", with: "")
        } else {
            return ("\(round(to: 0))").replacingOccurrences(of: ".0", with: "")
        }
    }
}
