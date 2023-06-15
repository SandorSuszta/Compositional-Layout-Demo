//
//  ViewController.swift
//  Compositional Layout Demo
//
//  Created by Nataliia Shusta on 15/06/2023.
//

import UIKit

class ViewController: UIViewController {
    
    //3. Setup sections
    enum Section {
        case main
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureCollectionView()
        initialSnapshot()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .blue
        collectionView.register(LabelCell.self, forCellWithReuseIdentifier: "LabelCell")
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.textLabel.text = "\(item)"
            cell.backgroundColor = .systemRed
            return cell
        }
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1...100), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        //1. Create size and item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //2. Create and configure group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //3. Create section
        let section = NSCollectionLayoutSection(group: group)
        
        //4. Create layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

