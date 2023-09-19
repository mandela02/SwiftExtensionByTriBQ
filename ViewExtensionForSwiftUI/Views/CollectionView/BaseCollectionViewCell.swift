//
//  BaseCollectionViewCell.swift
//  CannabisViews
//
//  Created by TriBQ on 12/04/2023.
//

import Foundation
import SwiftUI

open class BaseCollectionViewCell<Content: View>: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.removeAllSubviews()
    }

    public func setupView(content: Content) {
        let view = content.uiView
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)

        self.contentView.backgroundColor = .clear
        view.backgroundColor = .clear

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        view.layoutIfNeeded()
        layoutIfNeeded()
    }
}
