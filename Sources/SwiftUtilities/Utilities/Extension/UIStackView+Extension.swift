//
//  UIStackView+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/8/2022.
//

import UIKit

public extension UIStackView {
    func removeAllArrangedSubviews() {
        while arrangedSubviews.count > 0 {
            arrangedSubviews.first?.removeFromSuperview()
        }
    }
    
    func addBackground(color: UIColor, radiusSize: CGFloat = 10) {
        subviews.forEach { if $0.tag == 0 { $0.removeFromSuperview() } }
        let subView = UIView(frame: bounds)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
        
        subView.tag = 0
        
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
