//
//  UIAlertController+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import UIKit

public protocol EnumName {
    func getName() -> String
}

public extension UIAlertController {
    static func showActionSheet<T: CaseIterable & EnumName>(source: T.Type,
                                                            title: String,
                                                            message: String,
                                                            optionTitle: [T: String] = [:],
                                                            cancelButtontTitle: String = "Cancel",
                                                            onTap: @escaping (T) -> Void) {
        let actionSheet: UIAlertController = UIAlertController(title: title,
                                                               message: message,
                                                               preferredStyle: .actionSheet)
        
        actionSheet.overrideUserInterfaceStyle = .light
        
        for action in T.allCases {
            let alertAction = UIAlertAction(title: optionTitle[action] ?? action.getName(),
                                            style: .default,
                                            handler: { _ in
                                                onTap(action)
                                            })
            actionSheet.addAction(alertAction)
        }
        
        let cancelAlertAction = UIAlertAction(title: cancelButtontTitle,
                                              style: .cancel,
                                              handler: {_ in })
        
        actionSheet.addAction(cancelAlertAction)
        
        UIApplication.topViewController()?.present(actionSheet, animated: true, completion: nil)
    }
}
