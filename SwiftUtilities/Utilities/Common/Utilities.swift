//
//  Utilities.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

public struct Utilities {
    static func getWindowSize() -> CGSize {
        return getWindowBound().size
    }
    
    static func getWindowBound() -> CGRect {
        guard
            let windowBound = UIViewController.window?.bounds
        else {
            return .zero
        }
        
        return windowBound
    }
    
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var version: String {
        let dictionary = Bundle.main.infoDictionary!
        return dictionary["CFBundleShortVersionString"] as? String ?? "1"
    }
}
