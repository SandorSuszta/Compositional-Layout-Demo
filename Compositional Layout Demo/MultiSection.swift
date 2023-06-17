//
//  MultiSection.swift
//  Compositional Layout Demo
//
//  Created by Nataliia Shusta on 16/06/2023.
//

import UIKit

enum Section: Int, CaseIterable {
    case marketCards
    case crytoCoins
    
    var columnCount: Int {
        switch self {
        case .marketCards:
            return 4
        case .crytoCoins:
            return 1
        }
    }
}

class ViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    
    private var dataSource: DataSource!
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: MarketCompositionalLayout())
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureDataSource()

        setupConstraints()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(LabelCell.self, forCellWithReuseIdentifier: "LabelCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseID)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
       
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _ ) -> NSCollectionLayoutSection? in
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            
            let columns = sectionType.columnCount
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/CGFloat(columns)), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupHeight = columns == 1 ?
                NSCollectionLayoutDimension.absolute(200) :
                NSCollectionLayoutDimension.fractionalWidth(1/CGFloat(columns))
           
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            
            //configure header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as? LabelCell else { fatalError("Cant deque a cell")}
            
            
            cell.textLabel.text = "\(item)"
            
            if indexPath.section == 0 {
                cell.backgroundColor = .red
            } else {
                cell.backgroundColor = .green
            }
            return cell
        })
        //suolementary view provider
        
//        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
//            
//            if indexPath.section == 1 {
//                
//                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseID, for: indexPath) as? HeaderView else { fatalError("Couldnt deque a header") }
//                
//                headerView.textLabel.text = "\(Section.allCases[indexPath.section])".capitalized
//                return headerView
//            }
//            
//            return UICollectionReusableView()
//        }
        
        //snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.marketCards, .crytoCoins])
        snapshot.appendItems(Array(1...3), toSection: .marketCards)
        snapshot.appendItems(Array(4...50),toSection: .crytoCoins)
        
        dataSource.apply(snapshot)
    }
    
    
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
    }
}
