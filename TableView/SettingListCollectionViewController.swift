//
//  SettingListCollectionViewController.swift
//  TableView
//
//  Created by NERO on 7/20/24.
//

import UIKit
import SnapKit

final class SettingListCollectionViewController: UIViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Setting, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureDataSource()
        applySnapshot()
    }
}

extension SettingListCollectionViewController {
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Setting, String>()
        snapshot.appendSections(Setting.allCases)
        snapshot.appendItems(Setting.total.options, toSection: .total)
        snapshot.appendItems(Setting.personal.options, toSection: .personal)
        snapshot.appendItems(Setting.others.options, toSection: .others)
        dataSource.apply(snapshot)
    }
    
    private func configureDataSource() {
        var registration: UICollectionView.CellRegistration<UICollectionViewListCell, String> = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier
            content.textProperties.color = .white
            content.textProperties.font = .systemFont(ofSize: 13, weight: .light)
            cell.contentConfiguration = content
           
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .black
            cell.backgroundConfiguration = backgroundConfig
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var content = UIListContentConfiguration.groupedHeader()
            switch Setting.allCases[indexPath.section] {
            case .total:
                content.text = Setting.total.category
            case .personal:
                content.text = Setting.personal.category
            case .others:
                content.text = Setting.others.category
            }
            content.textProperties.color = .gray
            content.textProperties.font = .boldSystemFont(ofSize: 15)
            supplementaryView.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = .black
        configuration.showsSeparators = true
        configuration.separatorConfiguration.color = .darkGray
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}

extension SettingListCollectionViewController {
    private func setupView() {
        view.backgroundColor = .black
        collectionView.backgroundColor = .black
        navigationItem.title = "설정"
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
}
