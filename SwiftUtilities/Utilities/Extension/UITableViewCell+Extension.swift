//
//  UITableViewCell+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/8/2022.
//

import Foundation
import UIKit

public extension UITableViewCell {
    static var reuseID: String {
        return className
    }
}

@IBDesignable public extension UITableViewCell {
    @IBInspectable var selectedColor: UIColor? {
        get {
            return selectedBackgroundView?.backgroundColor
        }
        
        set {
            if let color = newValue {
                selectedBackgroundView = UIView()
                selectedBackgroundView!.backgroundColor = color
            } else {
                selectedBackgroundView = nil
            }
        }
    }
}
