//
//  CustomCellForCollectionView.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/22/24.
//


import UIKit

//MARK: - NftCollectionViewCell
final class NftCollectionViewCell: UICollectionViewCell {
    
    weak var view: CurrentCollectionNftViewController?
    
    //MARK: - Public Properties
    static let identifier = "NftCollectionViewCell"
    var indexPath: IndexPath?
    
    //MARK: - Private properties
    private var idNft: String?
    private var likeState: Bool = false
    
    //MARK: - Private UI properties
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var imageView = UIImageView()
    private lazy var likeButton = UIButton()
    private lazy var ratingView = StarRatingView()
    private lazy var nameLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var cartButton = UIButton()
    private lazy var nameAndPriceStackView = UIStackView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func configureCell(with model: CurrentCollectionCell) {
        self.idNft = model.id
        imageView.kf.setImage(with: model.url)
        nameLabel.text = model.nameNft.components(separatedBy: " ").first
        priceLabel.text = String(model.price) + " ETH"
        ratingView.update(rating: model.rating)
        cartButton.setImage(setCart(isInTheCart: model.isInTheCart), for: .normal)
        likeButton.setImage(setLike(isLiked: model.isLiked), for: .normal)
    }
    
    func setLike(isLiked: Bool) -> UIImage? {
        self.likeState = isLiked
        return likeState ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    func setCart(isInTheCart: Bool) -> UIImage? {
        isInTheCart ? UIImage(named: "AddToCart") : UIImage(named: "removeFromCart")
    }
}

private extension NftCollectionViewCell {
    
    //MARK: - Private methods
    func setupCell() {
        addSubViews()
        setupConstraints()
        configImageView()
        configureLikeButton()
        configNameLabel()
        configPriceLabel()
        configCartButton()
        configNameAndPriceStack()
    }
    
    func configImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
    }
    
    func configureLikeButton() {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .pinkForLikeButton
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }
    
    func configNameLabel() {
        nameLabel.textColor = .mainTextColor
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    func configPriceLabel() {
        priceLabel.textColor = .mainTextColor
        priceLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
    }
    
    func configCartButton() {
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        cartButton.tintColor = .blackForUI
        cartButton.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
    }
    
    func configNameAndPriceStack() {
        nameAndPriceStackView.axis = .vertical
        nameAndPriceStackView.alignment = .fill
        nameAndPriceStackView.distribution = .equalSpacing
        nameAndPriceStackView.spacing = 4
        nameAndPriceStackView.addArrangedSubview(nameLabel)
        nameAndPriceStackView.addArrangedSubview(priceLabel)
    }
    
    func addSubViews() {
        [imageView,
         likeButton,
         ratingView,
         nameAndPriceStackView,
         cartButton, activityIndicator].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            
            nameAndPriceStackView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            nameAndPriceStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameAndPriceStackView.widthAnchor.constraint(equalToConstant: 68),
            nameAndPriceStackView.heightAnchor.constraint(equalToConstant: 38),
            
            cartButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 25),
            activityIndicator.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    //MARK: - Actions
    @objc func didTapLikeButton() {
        guard let indexPath else { return }
        view?.updateLike(for: indexPath)
        activityIndicator.startAnimating()
    }
    
    @objc func didTapCartButton() {
        guard let indexPath else { return }
        view?.updateOrder(for: indexPath)
        activityIndicator.startAnimating()
    }
}


