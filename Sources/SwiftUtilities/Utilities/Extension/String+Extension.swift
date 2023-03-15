//
//  String+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation
import UIKit
import SwiftUI

// Validate the formatting of an email
private let firstPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
private let serverPart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
private let emailRegex = firstPart + "@" + serverPart + "[A-Za-z]{2,8}"
private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

// Validate that a password contains at least one uppercase letter, one lowercase letter, one number, and is at least 8 characters long
private let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
private let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

public extension String {
    var isBlank: Bool { trimmingCharacters(in: CharacterSet.whitespaces).isEmpty }

    var isEmail: Bool { emailPredicate.evaluate(with: self) }

    var isValidPassword: Bool { passwordPredicate.evaluate(with: self) }

    var isValidPhoneNumber: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }

    var isNumeric: Bool {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    var asInt: Int? {
        Int(self)
    }

    var asData: Data? {
        data(using: .utf8)
    }
    
    var asDouble: Double {
        return Double(self) ?? 0.0
    }

    func capAt(_ maxLength: Int) -> String {
        (count > maxLength) ? (String(prefix(maxLength)) + "...") : self
    }

    /// Remove non numeric characters from a string
    var numericOnly: String {
        let allowedCharacters = CharacterSet(charactersIn: "+0123456789").inverted
        let inputString = components(separatedBy: allowedCharacters)
        return inputString.joined(separator: "")
    }

    /// Capitalize the first letter
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }

    /// Capitalize the first letter
    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }

    subscript(i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript(r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func toObject<T: Decodable>(ofType _: T.Type) -> T? {
        guard let data = asData else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(T.self, from: data)
    }

    func tryToObject<T: Decodable>(ofType _: T.Type) throws -> T? {
        guard let data = asData else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(T.self, from: data)
    }
}

public extension String {
    func addAttribute(color: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    
    func addAttribute(fontName: String, fontSize: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize)]
        if let color = color {
            attributes.updateValue(color, forKey: .foregroundColor)
        }
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func addAttribute(lineSpacing: CGFloat, lineBreakMode: NSLineBreakMode) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.lineBreakMode = lineBreakMode
        return NSMutableAttributedString(string: self, attributes: [.paragraphStyle: style])
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 5, alignment: NSTextAlignment = .left) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        return NSAttributedString(string: self, attributes: [.paragraphStyle: style])
    }
    
    func getWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font: font], context: nil)
        return actualSize.width
    }
    
    func getFont(fontSize: CGFloat, isBold: Bool = false) -> UIFont {
        if let font = UIFont(name: self, size: fontSize) {
            return font
        }
        return isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
    }
    
    func addAttribute(highlightTexts: [String] = [], highlightColor: UIColor = .black, spacing: CGFloat = 5, alignment: NSTextAlignment = .justified) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        for text in highlightTexts {
            do {
                let regex = try NSRegularExpression(pattern: text.trimmingCharacters(in: .whitespacesAndNewlines), options: .caseInsensitive)
                let range = NSRange(location: 0, length: self.utf16.count)
                for match in regex.matches(in: self, options: .withTransparentBounds, range: range) {
                    attributedString.addAttribute(.foregroundColor, value: highlightColor, range: match.range)
                }
            } catch {
                NSLog("Error creating regular expresion: \(error)")
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = alignment
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: self.count))
        
        return attributedString
    }
    
    func getHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font: font], context: nil)
        return actualSize.height
    }
    
    func addAttribute(lineSpacing: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        return NSMutableAttributedString(string: self, attributes: [.paragraphStyle: style])
    }
    
    func setForegroundColor(highlightTexts: [String], color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        for text in highlightTexts {
            do {
                let regex = try NSRegularExpression(pattern: text.trimmingCharacters(in: .whitespacesAndNewlines), options: .caseInsensitive)
                let range = NSRange(location: 0, length: self.utf16.count)
                for match in regex.matches(in: self, options: .withTransparentBounds, range: range) {
                    attributedString.addAttribute(.foregroundColor, value: color, range: match.range)
                }
            } catch {
                NSLog("Error creating regular expresion: \(error)")
            }
        }
        
        return attributedString
    }
    
    func substring(with nsRange: NSRange) -> String? {
        guard let range = Range(nsRange, in: self) else { return nil }
        return String(self[range])
    }
    
    func formatStringTypeWith(text: String) -> String {
        return self.replacingOccurrences(of: "%@", with: text)
    }
}

public extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                    indices.append(range.lowerBound)
                    startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                    result.append(range)
                    startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    private func getFileURL() -> URL? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let folderURL = documentURL.appendingPathComponent("")
        return folderURL.appendingPathComponent("\(self).png")
    }
    
    func removeImageFile() {
        guard let fileURL = getFileURL() else { return }
        FileManager.default.deleteFile(at: fileURL)
    }
}

public extension String {
    init(resourceName: String, localizedKey key: String) {
        var bundle: Bundle? = Bundle.main
        let resourceName = resourceName
        if let path = Bundle.main.path(forResource: resourceName,
                                       ofType: "lproj") {
            bundle = Bundle(path: path)
        }
        self = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}

public extension String {
    var uiImage: UIImage? {
        return UIImage(named: self)
    }
    
    var uiSystemImage: UIImage? {
        return UIImage(systemName: self)
    }
    
    var image: Image {
        return Image(self)
    }
    
    var systemImage: Image {
        return Image(systemName: self)
    }
    
    var color: Color {
        return Color(hex: self)
    }
    
    var uiColor: UIColor {
        return UIColor(self)
    }
}

public extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
         let fontAttributes = [NSAttributedString.Key.font: font]
         let size = self.size(withAttributes: fontAttributes)
         return size.width
     }
}
