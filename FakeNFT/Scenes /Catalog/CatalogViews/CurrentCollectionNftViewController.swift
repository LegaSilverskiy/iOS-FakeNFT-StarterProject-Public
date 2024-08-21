//
//  CurrentCollectionNftViewController.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/19/24.
//

import Foundation
import UIKit

final class CurrentCollectionNftViewController: UIViewController {
    
    //MARK: - UI_PROPERTIES
    private let collectionNft = UICollectionView()
    //MARK: - LIFE_CIRCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - PUBLIC_METHODS
    //MARK: - PRIVATE_METHODS
    //MARK: - CONFIGURE_UI_METHODS
    
    private func configureUI() {
        
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionView() {
        
    }
    
    private func addSubviews() {
        
    }
    
    private func setupConstraints() {
        
    }
    
}

//MARK: - COLLECTION_VIEW_DATASOURCE
extension CurrentCollectionNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    
    
}

//MARK: - COLLECTION_VIEW_DELEGATE
extension CurrentCollectionNftViewController: UICollectionViewDelegate {
    
}
