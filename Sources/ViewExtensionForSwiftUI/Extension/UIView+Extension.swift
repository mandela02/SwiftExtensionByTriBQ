//
//  File.swift
//  
//
//  Created by TriBQ on 30/05/2023.
//

import Foundation
import UIKit

extension UIView {
    func removeAllSubviews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
}
