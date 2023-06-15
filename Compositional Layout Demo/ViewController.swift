//
//  ViewController.swift
//  Compositional Layout Demo
//
//  Created by Nataliia Shusta on 15/06/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configureCollectionView()
    }
    
    private func configureCollectionView() {}
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        //1. Create size and item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalWidth(1.0)
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

