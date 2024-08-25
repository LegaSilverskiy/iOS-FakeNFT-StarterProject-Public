//
//  CurrentCollectionNftViewController.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/19/24.
//

import Foundation
import UIKit

final class CurrentCollectionNftViewController: UIViewController {
    
    // MARK: - Private UI Properties
    private let collectionNft = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout())
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Public methods
    
    //MARK: - Private methods
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
    }
    
    private func configureUI() {
        configureView()
        setupCollectionView()
        addSubviews()
        setupConstraints()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionView() {
        collectionNft.backgroundColor = .systemBackground
        collectionNft.dataSource = self
        collectionNft.delegate = self
        collectionNft.register(CustomCellForCollectionView.self, forCellWithReuseIdentifier: CustomCellForCollectionView.reuseIdentifier)
    }
    
    private func addSubviews() {
        view.addSubview(collectionNft)
    }
    
    private func setupConstraints() {
        collectionNft.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionNft.topAnchor.constraint(equalTo: view.topAnchor),
            collectionNft.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionNft.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionNft.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

//MARK: - UICollectionViewDatasource
extension CurrentCollectionNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCellForCollectionView.reuseIdentifier, for: indexPath)
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate
extension CurrentCollectionNftViewController: UICollectionViewDelegate {
    
}
