//
//  UserNFTCollectionCell.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//
import Kingfisher
import UIKit

protocol UserNFTCollectionCellDelegate: AnyObject {
    func updateNftFavoriteStatus(index: Int)
    func updateNftOrderStatus(index: Int)
}

final class UserNFTCollectionCell: UICollectionViewCell {

    // MARK: - Public Properties
    static let reuseIdentifier = "userNFTCollectionCell"
    weak var delegate: UserNFTCollectionCellDelegate?

    // MARK: - Private Properties
    private var stars: [UIView] = []
    private var index: Int = 0

    private lazy var nftImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var favoriteButton = {
        let button = UIButton.systemButton(with: .nftFavorites ?? UIImage(), target: self, action: #selector(favoriteButtonAction))
        button.tintColor = .textOnPrimary
        return button
    }()

    private lazy var nftRatingContainer = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()

    private lazy var nameLabel = {
        let nameLabel = UILabel()
        nameLabel.font = .bodyBold
        nameLabel.textColor = .tabBarItemsTintColor
        nameLabel.textAlignment = .left

        return nameLabel
    }()

    private lazy var priceLabel = {
        let priceLabel = UILabel()
        priceLabel.font = .caption3
        priceLabel.textColor = .tabBarItemsTintColor
        priceLabel.textAlignment = .left

        return priceLabel
    }()

    private lazy var cartButton = {
        let button = UIButton.systemButton(with: .nftAddToCart ?? UIImage(), target: self, action: #selector(cartButtonAction))
        button.tintColor = .tabBarItemsTintColor
        return button
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUIElements()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configure(with params: NftCellParams) {
        self.index = params.index

        if let url = URL(string: params.image) {
            updateNFTImage(url: url)
        }

        updateFavoriteButton(with: params.isFavorite)
        updateCartPicture(with: params.isInCart)
        nameLabel.text = params.name
        priceLabel.text = params.price
        updateRatingStars(with: params.rating)
    }

    // MARK: - IBAction
    @objc private func favoriteButtonAction() {
        delegate?.updateNftFavoriteStatus(index: index)
    }

    @objc private func cartButtonAction() {
        delegate?.updateNftOrderStatus(index: index)
    }

    // MARK: - Private Methods
    private func setUIElements() {

        [nftImageView,
         favoriteButton,
         nftRatingContainer,
         nameLabel,
         priceLabel,
         cartButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        setupRatingStars()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            nftRatingContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftRatingContainer.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            nftRatingContainer.heightAnchor.constraint(equalToConstant: 12),

            cartButton.topAnchor.constraint(equalTo: nftRatingContainer.bottomAnchor, constant: 5),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: cartButton.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: cartButton.bottomAnchor)
        ])
    }

    private func updateNFTImage(url: URL) {
                        nftImageView.kf.indicatorType = .activity
                        nftImageView.kf.setImage(
                            with: url
                        )
    }

    private func setupRatingStars() {
        for _ in  0...4 {
            let star  = UIImageView(
                image: UIImage(
                    systemName: "star.fill",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 12
                    )
                )
            )
            star.tintColor = .segmentInactive
            star.translatesAutoresizingMaskIntoConstraints = false
            nftRatingContainer.addArrangedSubview(star)
            stars.append(star)
        }
    }

    private func updateRatingStars(with rating: Int) {
        for (index, star) in stars.enumerated() {
            star.tintColor = index < rating ? .yellowStar : .segmentInactive
        }
    }

    private func updateFavoriteButton(with state: Bool) {
        favoriteButton.tintColor = state ? .redFavoriteButton : .textOnPrimary
    }

    private func updateCartPicture(with state: Bool) {
        cartButton.setImage(state ? .nftDeleteFromCart : .nftAddToCart, for: .normal)
    }
}
