//
//  CustomCellForCollectionView.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/22/24.
//


import Kingfisher
import UIKit

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
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
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
        frameView.layer.masksToBounds = true
        frameView.layer.cornerRadius = 10
        frameView.layer.cornerCurve = .continuous
    }
    
    func configureImageNftView() {
        
    }
    
    func configureNameNftTitle() {
        nameNftTitle.font = .bodyRegular
    }
    
    func configureCurrencyNftTitle() {
        nameNftTitle.font = .bodyRegular
    }
    
    func configureLikeButtonNft() {
        likeButtonNft.tintColor = .textOnPrimary
    }
    
    func configureCartButtonNft() {
        cartButtonNft.tintColor = .tabBarItemsTintColor
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
    
    func setupFrameView() {
        frameView.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        contentView.addSubview(frameView)
        frameView.addSubview(imageNftView)
        imageNftView.addSubview(likeButtonNft)
        frameView.addSubview(nftRatingContainer)
        frameView.addSubview(nameNftTitle)
        frameView.addSubview(currencyNftTitle)
        frameView.addSubview(cartButtonNft)
        
        
    }
    
    func setupConstraints() {
        frameView.translatesAutoresizingMaskIntoConstraints = false
        imageNftView.translatesAutoresizingMaskIntoConstraints = false
        nameNftTitle.translatesAutoresizingMaskIntoConstraints = false
        currencyNftTitle.translatesAutoresizingMaskIntoConstraints = false
        likeButtonNft.translatesAutoresizingMaskIntoConstraints = false
        cartButtonNft.translatesAutoresizingMaskIntoConstraints = false
        nftRatingContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            frameView.topAnchor.constraint(equalTo: contentView.topAnchor),
            frameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            frameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            frameView.heightAnchor.constraint(equalToConstant: 192),
            
            imageNftView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageNftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageNftView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageNftView.heightAnchor.constraint(equalTo: imageNftView.widthAnchor),
            
            likeButtonNft.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButtonNft.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            nftRatingContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftRatingContainer.topAnchor.constraint(equalTo: imageNftView.bottomAnchor, constant: 8),
            nftRatingContainer.heightAnchor.constraint(equalToConstant: 12),

            cartButtonNft.topAnchor.constraint(equalTo: nftRatingContainer.bottomAnchor, constant: 5),
            cartButtonNft.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButtonNft.widthAnchor.constraint(equalToConstant: 40),

            nameNftTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameNftTitle.topAnchor.constraint(equalTo: cartButtonNft.topAnchor),
            nameNftTitle.trailingAnchor.constraint(equalTo: cartButtonNft.leadingAnchor),

            currencyNftTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currencyNftTitle.bottomAnchor.constraint(equalTo: cartButtonNft.bottomAnchor)
            
//            imageNftView.topAnchor.constraint(equalTo: frameView.topAnchor),
//            imageNftView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
//            imageNftView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
//            imageNftView.bottomAnchor.constraint(equalTo: nftRatingContainer.topAnchor),
//
//            likeButtonNft.topAnchor.constraint(equalTo: imageNftView.topAnchor, constant: 11),
//            likeButtonNft.leadingAnchor.constraint(equalTo: imageNftView.leadingAnchor, constant: 77),
//            likeButtonNft.trailingAnchor.constraint(equalTo: imageNftView.trailingAnchor, constant: -10),
//            likeButtonNft.bottomAnchor.constraint(equalTo: imageNftView.bottomAnchor, constant: -79),
//
//            nftRatingContainer.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
//            nftRatingContainer.trailingAnchor.constraint(equalTo: cartButtonNft.leadingAnchor),
//            nftRatingContainer.bottomAnchor.constraint(equalTo: nameNftTitle.topAnchor),
//
//            nameNftTitle.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
//            nameNftTitle.trailingAnchor.constraint(equalTo: cartButtonNft.leadingAnchor),
//            nameNftTitle.bottomAnchor.constraint(equalTo: currencyNftTitle.topAnchor),
//
//            currencyNftTitle.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
//            currencyNftTitle.trailingAnchor.constraint(equalTo: cartButtonNft.leadingAnchor),
//            currencyNftTitle.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -21),
//
//            cartButtonNft.topAnchor.constraint(equalTo: imageNftView.bottomAnchor, constant: 24),
//            cartButtonNft.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
//            cartButtonNft.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -20)
        ])
    }
}
