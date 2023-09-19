//
//  UIApplication+Extensino.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation
import UIKit

public extension UIApplication {
    class func topViewController(base: UIViewController? = UIViewController.window?.rootViewController) -> UIViewController? {        
        if let navigationController = base as? UINavigationController {
            return topViewController(base: navigationController.visibleViewController)
        }
        if let tabBarController = base as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
