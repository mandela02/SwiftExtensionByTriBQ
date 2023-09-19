//
//  DateFormatter+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation

public extension DateFormatter {
    convenience init(dateFormat: String, localeIdentifier: String = "en-US") {
        self.init()
        self.dateFormat = dateFormat
        self.locale = Locale(identifier: localeIdentifier)
        self.calendar = .gregorian
    }
    
    convenience init(dateFormat: String, locale: Locale) {
        self.init()
        self.dateFormat = dateFormat
        self.locale = locale
        self.calendar = .gregorian
    }
}
