//
//  Bool+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation

public extension Bool {
    /// Convert a boolean to a string ("0" for false and "1" for true)
    var asString: String { self ? "1" : "0" }

    /// Convert a boolean to an integer (0 for false and 1 for true)
    var asInt: Int { self ? 1 : 0 }

    /// Convert an integer to data
    var asData: Data? { asString.asData }
}
