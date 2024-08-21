//
//  CustomCellForCollectionView.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/21/24.
//

import UIKit
import WebKit

final class CustomCellForCollectionView: UICollectionViewCell {
    
    static let reuseIdentifier = "CollectionInCurrentNftCustomViewCell"
    
    //MARK: - PRIVATE_PROPERTIES
    private var frameView = UIView()
    private var imageNftView = UIImageView()
    private var ratingStars: [UIView] = []
    private var nameNftTitle = UILabel()
    private var currencyNftTitle = UILabel()
    private var likeButtonNft = UIButton()
    private var cartButtonNft = UIButton()
    private var nftRatingContainer = UIStackView()
    private let webView = WKWebView()
}

private extension CustomCellForCollectionView {
    
    //MARK: - SETUP_UI
    private func setupRatingStars() {
        ratingStars = (0..<5).map { _ in
            let star = UIImageView()
            
            star.image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))
            star.translatesAutoresizingMaskIntoConstraints = false
            star.contentMode = .scaleAspectFit
            star.tintColor = .segmentInactive
            nftRatingContainer.addArrangedSubview(star)
            
            return star
        }
    }
    
     func addSubviews() {
         frameView.translatesAutoresizingMaskIntoConstraints = false
         imageNftView.translatesAutoresizingMaskIntoConstraints = false
         nameNftTitle.translatesAutoresizingMaskIntoConstraints = false
         currencyNftTitle.translatesAutoresizingMaskIntoConstraints = false
         likeButtonNft.translatesAutoresizingMaskIntoConstraints = false
         cartButtonNft.translatesAutoresizingMaskIntoConstraints = false
         nftRatingContainer.translatesAutoresizingMaskIntoConstraints = false
         
         contentView.addSubview(frameView)
         frameView.addSubview(imageNftView)
         imageNftView.addSubview(likeButtonNft)
         frameView.addSubview(nftRatingContainer)
         frameView.addSubview(nameNftTitle)
         frameView.addSubview(currencyNftTitle)
         frameView.addSubview(cartButtonNft)
         
         NSLayoutConstraint.activate([
         
         ])
    }
    
     func setupConstraints() {
        
    }
}

//MARK: - UI_CONFIGURE_METHODS
private extension CustomCellForCollectionView {
    
    func configureUI() {
        
    }
    
    func configureFramveView() {
        
    }
    
    func configureImageNftView() {
        
    }
    
    func configureNameNftTitle() {
        
    }
    
    func configureCurrencyNftTitle() {
        
    }
    func configureLikeButtonNft() {
        
    }
    
    func configureCartButtonNft() {
        
    }
}
