//
//  NSObject+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/8/2022.
//

import UIKit

public extension NSObject {
    @nonobjc class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return type(of: self).className
    }
}
