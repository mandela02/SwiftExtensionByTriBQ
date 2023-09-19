//
//  File.swift
//  
//
//  Created by TriBQ on 17/02/2023.
//

import Foundation
import CoreLocation
import Contacts

extension CLPlacemark {
    var address: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress,
                                               style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
