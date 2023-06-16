//
//  MultiSection.swift
//  Compositional Layout Demo
//
//  Created by Nataliia Shusta on 16/06/2023.
//

import UIKit

enum Section: Int, CaseIterable {
    case grid
    case single
    
    var columnCount: Int {
        switch self {
        case .grid:
            return 4
        case .single:
            return 1
        }
    }
}

class ViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()

        setupConstraints()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .blue
        collectionView.register(LabelCell.self, forCellWithReuseIdentifier: "LabelCell")
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        //1. Create size and item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //Add insets to item
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        //2. Create and configure group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        //3. Create section
        let section = NSCollectionLayoutSection(group: group)
        
        //4. Create layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
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
