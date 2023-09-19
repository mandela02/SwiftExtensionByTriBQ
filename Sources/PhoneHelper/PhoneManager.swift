//
//  PhoneManager.swift
//  PhoneHelper
//
//  Created by Tri Bui Q. VN.Hanoi on 03/03/2023.
//

import Foundation
import PhoneNumberKit

public struct PhoneHelper {
    public static var shared = PhoneHelper()
    private init() {}

    private let phoneNumberKit = PhoneNumberKit()

    private var locale: String = "en"
    
    public mutating func setLocale(locale: String) {
        self.locale = locale
    }
    
    public func getRegionCodes() -> [String] {
        phoneNumberKit.allCountries()
    }

    public func getCountryName(from regionCode: String) -> String {
        let locale = Locale(identifier: self.locale)
        if let country = locale
            .localizedString(forRegionCode: regionCode) {
            return country
        } else {
            return ""
        }
    }

    public func getFlag(from regionCode: String) -> String {
        return regionCode.flag
    }

    public func getCode(from regionCode: String) -> String {
        if let code = phoneNumberKit.countryCode(for: regionCode) {
            return String(code)
        } else {
            return ""
        }
    }

    public func getPhoneNumber(from number: String) -> String {
        do {
            let phoneNumber = try phoneNumberKit.parse(number, ignoreType: true)
            return phoneNumberKit.format(phoneNumber, toType: .national)
        } catch {
            return ""
        }
    }

    public func createPhoneNumber(from number: String, regionCode: String) -> String {
        do {
            let phoneNumber = try phoneNumberKit.parse(number, withRegion: regionCode, ignoreType: true)
            return phoneNumberKit.format(phoneNumber, toType: .international)
        } catch {
            return ""
        }
    }

    public func getPlaceHolder(of regionCode: String) -> String {
        if let phone = phoneNumberKit.getExampleNumber(forCountry: regionCode)?.numberString {
            return phone
        } else {
            return ""
        }
    }

    public func getRegionCode(from number: String) -> String {
        do {
            let phoneNumber = try phoneNumberKit.parse(number, ignoreType: true)
            if let regionCode = phoneNumberKit.mainCountry(forCode: phoneNumber.countryCode) {
                return regionCode
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
    
    public func validatePhoneNumber(number: String, region: String) -> String? {
        let validatedPhoneNumber = try? self.phoneNumberKit.parse(number, withRegion: region).nationalNumber
        if let validatedPhoneNumber = validatedPhoneNumber {
            return String(validatedPhoneNumber)
        }
        return nil
    }

    public func isPhoneValid(number: String) -> Bool {
        return phoneNumberKit.isValidPhoneNumber(number)
    }
}

public extension String {
    var flag: String {
        let base: UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    var regionCodeNameAndFlag: String {
        let text = PhoneHelper.shared.getFlag(from: self)
        + " "
        + PhoneHelper.shared.getCountryName(from: self)
        + " +"
        + PhoneHelper.shared.getCode(from: self)

        return text
    }
    
    var regionCodeAndFlag: String {
        let text = PhoneHelper.shared.getFlag(from: self)
        + " "
        + self
        + " +"
        + PhoneHelper.shared.getCode(from: self)

        return text
    }
}
