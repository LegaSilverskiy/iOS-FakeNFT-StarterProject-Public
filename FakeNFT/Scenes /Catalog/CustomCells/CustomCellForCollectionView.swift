//
//  CustomCellForCollectionView.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/22/24.
//


import UIKit
import WebKit

final class CustomCellForCollectionView: UICollectionViewCell {
    
    static let reuseIdentifier = "CollectionInCurrentNftCustomViewCell"
    
    //MARK: - Private properties
    private var frameView = UIView()
    private var imageNftView = UIImageView()
    private var ratingStars: [UIView] = []
    private var nameNftTitle = UILabel()
    private var currencyNftTitle = UILabel()
    private var likeButtonNft = UIButton()
    private var cartButtonNft = UIButton()
    private var nftRatingContainer = UIStackView()
    private let webView = WKWebView()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - Setup UI Extension
private extension CustomCellForCollectionView {
    
    func configureUI() {
        addSubviews()
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
    
    
    func setupRatingStars() {
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
            frameView.topAnchor.constraint(equalTo: contentView.topAnchor),
            frameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            frameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            frameView.heightAnchor.constraint(equalToConstant: 192),
            
            imageNftView.topAnchor.constraint(equalTo: frameView.topAnchor),
            imageNftView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            imageNftView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            imageNftView.bottomAnchor.constraint(equalTo: nftRatingContainer.topAnchor),
            
            likeButtonNft.topAnchor.constraint(equalTo: imageNftView.topAnchor, constant: 11),
            likeButtonNft.leadingAnchor.constraint(equalTo: imageNftView.leadingAnchor, constant: 77),
            likeButtonNft.trailingAnchor.constraint(equalTo: imageNftView.trailingAnchor, constant: -10),
            likeButtonNft.bottomAnchor.constraint(equalTo: imageNftView.bottomAnchor, constant: -79),
            
            nftRatingContainer.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            nftRatingContainer.trailingAnchor.constraint(equalTo: cartButtonNft.leadingAnchor),
            nftRatingContainer.bottomAnchor.constraint(equalTo: nameNftTitle.topAnchor),
            
            nameNftTitle.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            nameNftTitle.trailingAnchor.constraint(equalTo: cartButtonNft.leadingAnchor),
            nameNftTitle.bottomAnchor.constraint(equalTo: currencyNftTitle.topAnchor),
            
            currencyNftTitle.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            currencyNftTitle.trailingAnchor.constraint(equalTo: cartButtonNft.leadingAnchor),
            currencyNftTitle.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -21),
            
            cartButtonNft.topAnchor.constraint(equalTo: imageNftView.bottomAnchor, constant: 24),
            cartButtonNft.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            cartButtonNft.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -20)
        ])
    }
    
    func setupConstraints() {
        
    }
}
