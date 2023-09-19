//
//  LayoutBuilder.swift
//  CannabisViews
//
//  Created by TriBQ on 12/04/2023.
//

import Foundation
import UIKit

public struct LayoutBuilder {
    public static func defaultVertical() -> NSCollectionLayoutSection {
        .init(
            group: .vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [
                    .init(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalHeight(1)
                        )
                    )
                ]
            )
        )
    }

    public static func buildHorizontalScrollSectionLayout(
        itemSize: NSCollectionLayoutSize,
        layoutSize: NSCollectionLayoutSize
    ) -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitem: item, count: 1
        )
        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }

    public static func buildSingleCellSectionLayout(
        layoutSize: NSCollectionLayoutSize,
        sectionContentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = .zero
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionContentInset
        return section
    }

    public static func buildVerticalGridLayout(
        itemSize: NSCollectionLayoutSize,
        layoutSize: NSCollectionLayoutSize,
        sectionContentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        ),
        interItemSpacing: CGFloat = 20,
        column: Int = 2
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: item,
            count: column
        )
        group.interItemSpacing = .fixed(interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = sectionContentInset

        return section
    }
}
