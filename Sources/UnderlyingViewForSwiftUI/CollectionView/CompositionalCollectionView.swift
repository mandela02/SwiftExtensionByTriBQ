//
//  CompositionalCollectionView.swift
//  UnderlyingViewForSwiftUI
//
//  Created by Tri Bui Q. VN.Hanoi on 06/03/2023.
//

import Foundation
import SwiftUI

public struct CompositionalCollectionView<Section: Hashable, Item: Hashable>: UIViewControllerRepresentable {
    public init(
        shouldReload: Binding<Bool> = .constant(false),
        direction: Binding<GenericScrollDirection> = .constant(.up),
        contentOffset: Binding<CGPoint> = .constant(.zero),
        layout: UICollectionViewLayout,
        refreshBackgroundColor: Color = .clear,
        sections: @escaping () -> [Section],
        items: @escaping () -> [Section: [Item]],
        extraSetting: @escaping (UICollectionView) -> Void,
        cellProvider: @escaping ((UICollectionView, IndexPath, Item) -> UICollectionViewCell?),
        buildHeader: ((UICollectionView, IndexPath, Section) -> UICollectionReusableView?)? = nil,
        buildFooter: ((UICollectionView, IndexPath, Section) -> UICollectionReusableView?)? = nil,
        didSelectItem: ((UICollectionView, IndexPath, Section, Item) -> Void)? = nil,
        onRefresh: (() async -> Void)? = nil,
        onReachEnd: (() async -> Void)? = nil,
        onOverScroll: (() async -> Void)? = nil,
        willDisplay: ((UICollectionView, UICollectionViewCell, IndexPath) -> Void)? = nil,
        didEndDisplay: ((UICollectionView, UICollectionViewCell, IndexPath) -> Void)? = nil,
        didChangeScrollDirection: ((GenericScrollDirection) -> Void)? = nil,
        didChangeContentOffset: ((CGPoint) -> Void)? = nil
    ) {
        self._shouldReload = shouldReload
        self._direction = direction
        self._contentOffset = contentOffset
        self.layout = layout
        self.sections = sections
        self.items = items
        self.extraSetting = extraSetting
        self.cellProvider = cellProvider
        self.buildHeader = buildHeader
        self.buildFooter = buildFooter
        self.didSelectItem = didSelectItem
        self.onRefresh = onRefresh
        self.onOverScroll = onOverScroll
        self.onReachEnd = onReachEnd
        self.willDisplay = willDisplay
        self.didEndDisplay = didEndDisplay
        self.didChangeContentOffset = didChangeContentOffset
        self.didChangeScrollDirection = didChangeScrollDirection
        self.refreshBackgroundColor = refreshBackgroundColor
    }
    
    @Binding
    private var shouldReload: Bool
    
    @Binding
    private var direction: GenericScrollDirection

    @Binding
    private var contentOffset: CGPoint

    private let refreshBackgroundColor: Color

    private let layout: UICollectionViewLayout
    private let sections: () -> [Section]
    private let items: () -> [Section: [Item]]
    private let extraSetting: (UICollectionView) -> Void

    private var cellProvider: ((UICollectionView, IndexPath, Item) -> UICollectionViewCell?)
    private var buildHeader: ((UICollectionView, IndexPath, Section) -> UICollectionReusableView?)?
    private var buildFooter: ((UICollectionView, IndexPath, Section) -> UICollectionReusableView?)?

    private var didSelectItem: ((UICollectionView, IndexPath, Section, Item) -> Void)?
    private var willDisplay: ((UICollectionView, UICollectionViewCell, IndexPath ) -> Void)?
    private var didEndDisplay: ((UICollectionView, UICollectionViewCell, IndexPath ) -> Void)?
    private var onRefresh: (() async -> Void)?
    private var onReachEnd: (() async -> Void)?
    private var onOverScroll: (() async -> Void)?
    private var didChangeScrollDirection: ((GenericScrollDirection) -> Void)?
    private var didChangeContentOffset: ((CGPoint) -> Void)?

    public func makeUIViewController(context: Context) -> CompositionalCollectionViewController<Section, Item> {
        let snapshotForCurrentState = {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

            snapshot.appendSections(self.sections())

            self.sections().forEach { section in
                if let item = self.items()[section] {
                    snapshot.appendItems(item, toSection: section)
                }
            }
            return snapshot
        }

        let controller = CompositionalCollectionViewController<Section, Item>(layout: layout,
                                                                              snapshotForCurrentState: snapshotForCurrentState,
                                                                              cellProvider: cellProvider)

        extraSetting(controller.collectionView)

        controller.onChangeScrollDirection = { direction in
            self.direction = direction
            self.didChangeScrollDirection?(direction)
        }

        controller.buildHeader = buildHeader
        controller.buildFooter = buildFooter
        controller.onRefresh = onRefresh
        controller.onReachEnd = onReachEnd
        controller.onOverScroll = onOverScroll
        controller.willDisplay = willDisplay
        controller.didEndDisplay = didEndDisplay
        controller.didSelectItem = didSelectItem
        controller.onChangeContentOffset = {
            self.contentOffset = $0
            self.didChangeContentOffset?($0)
        }
        controller.refreshBackgroundColor = UIColor(self.refreshBackgroundColor)

        return controller
    }

    public func updateUIViewController(_ uiViewController: CompositionalCollectionViewController<Section, Item>, context: Context) {
        if shouldReload {
            uiViewController.updateUI()
            DispatchQueue.main.async {
                shouldReload = false
            }
        }
    }
}

public class CompositionalCollectionViewController<Section, Item>: UICollectionViewController, UICollectionViewDataSourcePrefetching where Section: Hashable, Item: Hashable {
    public init(
        layout: UICollectionViewLayout,
        snapshotForCurrentState: @escaping (() -> NSDiffableDataSourceSnapshot<Section, Item>),
        cellProvider: @escaping ((UICollectionView, IndexPath, Item) -> UICollectionViewCell?)
    ) {
        self.snapshotForCurrentState = snapshotForCurrentState
        self.cellProvider = cellProvider
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var snapshotForCurrentState: (() -> NSDiffableDataSourceSnapshot<Section, Item>)

    public var cellProvider: ((UICollectionView, IndexPath, Item) -> UICollectionViewCell?)
    public var buildHeader: ((UICollectionView, IndexPath, Section) -> UICollectionReusableView?)?
    public var buildFooter: ((UICollectionView, IndexPath, Section) -> UICollectionReusableView?)?

    public var didSelectItem: ((UICollectionView, IndexPath, Section, Item) -> Void)?
    public var onRefresh: (() async -> Void)?
    public var onReachEnd: (() async -> Void)?
    public var onOverScroll: (() async -> Void)?
    public var willDisplay: ((UICollectionView, UICollectionViewCell, IndexPath) -> Void)?
    public var didEndDisplay: ((UICollectionView, UICollectionViewCell, IndexPath) -> Void)?
    public var onChangeScrollDirection: ((GenericScrollDirection) -> Void)?
    public var onChangeContentOffset: ((CGPoint) -> Void)?
    public var refreshBackgroundColor: UIColor = .clear

    private var isLoadingMore = false
    private var isOverScrolling = false
    private lazy var thisRefreshControl = UIRefreshControl()
    private var defaultOffset: CGPoint?

    private var isLoaded = false

    lazy var dataSource: (UICollectionViewDiffableDataSource<Section, Item>)? = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView,
            cellProvider: cellProvider
        )
        return dataSource
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        collectionView.prefetchDataSource = self

        self.collectionView.refreshControl = thisRefreshControl
        thisRefreshControl.backgroundColor = refreshBackgroundColor

        // Creating view for extending background color
        thisRefreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let section = self.dataSource?.sectionIdentifier(for: indexPath.section) else {
                return nil
            }
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return self.buildHeader?(collectionView, indexPath, section)
            case UICollectionView.elementKindSectionFooter:
                return self.buildFooter?(collectionView, indexPath, section)
            default:
                return nil
            }
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isLoaded {
            var frame = self.collectionView.bounds
            frame.origin.y = -frame.size.height
            let backgroundView = UIView(frame: frame)
            backgroundView.autoresizingMask = .flexibleWidth
            backgroundView.backgroundColor = refreshBackgroundColor
            self.collectionView.insertSubview(backgroundView, at: 0)
            isLoaded = true
        }
    }

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource?.itemIdentifier(for: indexPath), let section = dataSource?.sectionIdentifier(for: indexPath.section) {
            didSelectItem?(collectionView, indexPath, section, item)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if collectionView.numberOfSections == 1 {
            if indexPaths.map({ $0.item }).contains(collectionView.numberOfItems(inSection: collectionView.numberOfSections - 1) - 5) && !isLoadingMore {
                Task {
                    isLoadingMore = true
                    await onReachEnd?()
                    isLoadingMore = false
                }
            }
        } else {
            if indexPaths.map({ $0.section }).contains(collectionView.numberOfSections - 1) && !isLoadingMore {
                Task {
                    isLoadingMore = true
                    await onReachEnd?()
                    isLoadingMore = false
                }
            }
        }
    }

    public override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        willDisplay?(collectionView, cell, indexPath)
    }

    public override func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        didEndDisplay?(collectionView, cell, indexPath)
    }

    @objc private func didPullToRefresh(_ sender: Any) {
        Task {
            await onRefresh?()
            self.thisRefreshControl.endRefreshing()
        }
    }

    public override func scrollViewWillBeginDragging(
        _ scrollView: UIScrollView
    ) {
        self.defaultOffset = scrollView.contentOffset
    }

    public override func scrollViewDidScroll(
        _ scrollView: UIScrollView
    ) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            if !isOverScrolling {
                Task {
                    isOverScrolling = true
                    await onOverScroll?()
                    isOverScrolling = false
                }
            }
        }

        guard let defaultOffset = defaultOffset else {
            return
        }

        let currentOffset = scrollView.contentOffset
        onChangeContentOffset?(currentOffset)

        if currentOffset.y + scrollView.height >= scrollView.contentSize.height {
            return
        }

        if currentOffset.y <= 0 {
            return
        }

        if currentOffset.y > defaultOffset.y {
            onChangeScrollDirection?(.up)
        } else {
            onChangeScrollDirection?(.down)
        }
    }

    public override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.defaultOffset = nil
    }
}

extension CompositionalCollectionViewController {
    private func configureDataSource() {
        let snapshot = snapshotForCurrentState()
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func updateUI() {
        let snapshot = snapshotForCurrentState()
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

